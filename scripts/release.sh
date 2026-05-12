#!/usr/bin/env bash
# FocusDex — Sparkle-ready release script
#
# Usage:
#   scripts/release.sh <version> '<release-notes-html>'
#
# Example:
#   scripts/release.sh 0.5.2 '<ul><li>Fixed timer bug</li><li>New icon</li></ul>'
#
# This script:
#   1. Bumps MARKETING_VERSION in project.yml
#   2. Regenerates the Xcode project (xcodegen)
#   3. Builds a Release .app
#   4. Packages it into a DMG
#   5. Computes sha256 + file size
#   6. Signs the update with Sparkle's sign_update (if present)
#   7. Appends a new <item> to website/appcast.xml
#   8. Creates a GitHub release with `gh release create`
set -euo pipefail

# ─── 1. Parse args ────────────────────────────────────────────────────────────
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <version> '<release-notes-html>'" >&2
  echo "Example: $0 0.5.2 '<ul><li>Fixed bug</li></ul>'" >&2
  exit 1
fi

VERSION="$1"
NOTES_HTML="$2"

# Resolve repo root (scripts/release.sh -> repo root)
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Sparkle uses two separate version strings:
#   sparkle:shortVersionString — the user-visible marketing version (e.g. "0.5.2")
#   sparkle:version            — the monotonic build number (CURRENT_PROJECT_VERSION)
# We derive the build number from the marketing version (digits only) so each
# release strictly increases. Override BUILD_NUMBER in the env if you want.
BUILD_NUMBER="${BUILD_NUMBER:-$(echo "$VERSION" | tr -d '.')}"

echo "→ Releasing FocusDex v${VERSION} (build ${BUILD_NUMBER})"

# ─── 2. Bump MARKETING_VERSION in project.yml ─────────────────────────────────
# sed -i '' is the macOS in-place form (BSD sed requires the empty backup arg).
# We match the indented MARKETING_VERSION line and replace its value.
echo "→ Bumping MARKETING_VERSION to ${VERSION} in project.yml..."
sed -i '' -E "s/^([[:space:]]*MARKETING_VERSION:[[:space:]]*).*$/\1\"${VERSION}\"/" project.yml
sed -i '' -E "s/^([[:space:]]*CURRENT_PROJECT_VERSION:[[:space:]]*).*$/\1\"${BUILD_NUMBER}\"/" project.yml

# ─── 3. Regenerate the Xcode project ──────────────────────────────────────────
if ! command -v xcodegen >/dev/null 2>&1; then
  echo "✗ xcodegen not found. Install with: brew install xcodegen" >&2
  exit 1
fi
echo "→ Running xcodegen generate..."
xcodegen generate

# ─── 4. Build Release ─────────────────────────────────────────────────────────
echo "→ Building Release configuration..."
xcodebuild \
  -project FocusDex.xcodeproj \
  -scheme FocusDex \
  -configuration Release \
  -derivedDataPath build/DerivedData \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build

APP_PATH="$ROOT/build/DerivedData/Build/Products/Release/FocusDex.app"
if [[ ! -d "$APP_PATH" ]]; then
  echo "✗ Build produced no app at $APP_PATH" >&2
  exit 1
fi
echo "✓ Built $APP_PATH"

# ─── 5. Package into a DMG ────────────────────────────────────────────────────
DMG_PATH="$ROOT/build/FocusDex.dmg"
rm -f "$DMG_PATH"

if [[ -x "$ROOT/scripts/build-dmg.sh" ]]; then
  # Defer to a dedicated DMG builder if one exists (e.g. one that adds a
  # styled background, /Applications symlink, etc.).
  echo "→ Building DMG via scripts/build-dmg.sh..."
  "$ROOT/scripts/build-dmg.sh" "$APP_PATH" "$DMG_PATH"
else
  # Inline hdiutil fallback: stage the .app into a temp dir alongside an
  # /Applications symlink so users can drag-install, then convert to a
  # compressed read-only DMG.
  echo "→ Building DMG with hdiutil (inline)..."
  STAGE="$(mktemp -d -t focusdex-dmg)"
  trap 'rm -rf "$STAGE"' EXIT
  cp -R "$APP_PATH" "$STAGE/"
  ln -s /Applications "$STAGE/Applications"
  hdiutil create \
    -volname "FocusDex" \
    -srcfolder "$STAGE" \
    -ov \
    -format UDZO \
    "$DMG_PATH" >/dev/null
fi

if [[ ! -f "$DMG_PATH" ]]; then
  echo "✗ DMG was not produced at $DMG_PATH" >&2
  exit 1
fi
echo "✓ DMG: $DMG_PATH"

# ─── 6. Compute sha256 + file size ────────────────────────────────────────────
# stat -f%z is BSD/macOS syntax. shasum is preinstalled on macOS.
DMG_SIZE="$(stat -f%z "$DMG_PATH")"
DMG_SHA256="$(shasum -a 256 "$DMG_PATH" | awk '{print $1}')"
echo "  size:   ${DMG_SIZE} bytes"
echo "  sha256: ${DMG_SHA256}"

# ─── 7. Sparkle EdDSA signature ───────────────────────────────────────────────
# Sparkle ships a `sign_update` binary which signs the DMG with the EdDSA
# private key stored in the Keychain. If the binary is missing we warn and
# omit the signature — useful for first-time / pre-Sparkle releases.
SIGN_UPDATE="$ROOT/scripts/sparkle/bin/sign_update"
ED_SIGNATURE=""
if [[ -x "$SIGN_UPDATE" ]]; then
  echo "→ Signing DMG with Sparkle's sign_update..."
  # sign_update prints something like:
  #   sparkle:edSignature="..." length="..."
  # We only need the edSignature value.
  SIGN_OUTPUT="$("$SIGN_UPDATE" "$DMG_PATH")"
  ED_SIGNATURE="$(echo "$SIGN_OUTPUT" | sed -nE 's/.*sparkle:edSignature="([^"]+)".*/\1/p')"
  if [[ -z "$ED_SIGNATURE" ]]; then
    echo "⚠ sign_update ran but no edSignature could be parsed. Output was:" >&2
    echo "$SIGN_OUTPUT" >&2
  else
    echo "✓ Signature: ${ED_SIGNATURE:0:32}..."
  fi
else
  echo "⚠ Sparkle sign_update not found at scripts/sparkle/bin/sign_update — skipping signature."
  echo "  Install Sparkle and drop sign_update there to enable signing."
fi

# ─── 8. Append <item> to website/appcast.xml ──────────────────────────────────
APPCAST="$ROOT/website/appcast.xml"
DOWNLOAD_URL="https://github.com/bendawg2010/FocusDex/releases/download/v${VERSION}/FocusDex.dmg"

# RFC 822 date format, required by RSS / Sparkle.
PUB_DATE="$(LC_TIME=en_US.UTF-8 date -u +"%a, %d %b %Y %H:%M:%S +0000")"

# Build the enclosure attribute list, conditionally including the signature.
ENCLOSURE_ATTRS="url=\"${DOWNLOAD_URL}\""
ENCLOSURE_ATTRS+=" sparkle:version=\"${BUILD_NUMBER}\""
ENCLOSURE_ATTRS+=" sparkle:shortVersionString=\"${VERSION}\""
ENCLOSURE_ATTRS+=" length=\"${DMG_SIZE}\""
ENCLOSURE_ATTRS+=" type=\"application/octet-stream\""
if [[ -n "$ED_SIGNATURE" ]]; then
  ENCLOSURE_ATTRS+=" sparkle:edSignature=\"${ED_SIGNATURE}\""
fi

# Compose the new <item>. CDATA wraps the HTML notes so we don't have to
# escape angle brackets in the user-provided string.
NEW_ITEM=$(cat <<EOF
    <item>
      <title>Version ${VERSION}</title>
      <pubDate>${PUB_DATE}</pubDate>
      <sparkle:version>${BUILD_NUMBER}</sparkle:version>
      <sparkle:shortVersionString>${VERSION}</sparkle:shortVersionString>
      <description><![CDATA[${NOTES_HTML}]]></description>
      <enclosure ${ENCLOSURE_ATTRS} />
    </item>
EOF
)

# Insert the new item just before </channel>. We rewrite the file via awk so we
# don't depend on GNU sed and so we can drop the multi-line block cleanly.
echo "→ Updating ${APPCAST}..."
TMP_APPCAST="$(mktemp -t focusdex-appcast)"
awk -v item="$NEW_ITEM" '
  /<\/channel>/ && !done { print item; done=1 }
  { print }
' "$APPCAST" > "$TMP_APPCAST"
mv "$TMP_APPCAST" "$APPCAST"
echo "✓ Appcast updated"

# ─── 9. Create the GitHub release ─────────────────────────────────────────────
if ! command -v gh >/dev/null 2>&1; then
  echo "✗ gh CLI not found. Install with: brew install gh" >&2
  echo "  (Then run: gh auth login)" >&2
  exit 1
fi

echo "→ Creating GitHub release v${VERSION}..."
gh release create "v${VERSION}" "$DMG_PATH" \
  --title "v${VERSION}" \
  --notes "$NOTES_HTML"

# `gh release view --json url` would also work; this is simpler and stable.
RELEASE_URL="https://github.com/bendawg2010/FocusDex/releases/tag/v${VERSION}"
APPCAST_URL="https://focusdex.pages.dev/appcast.xml"

# ─── 10. Done ─────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✓ FocusDex v${VERSION} released"
echo "  GitHub release: ${RELEASE_URL}"
echo "  Appcast:        ${APPCAST_URL}"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "Next: commit + push the updated project.yml and website/appcast.xml"
echo "      so Cloudflare Pages picks up the new appcast."
