#!/usr/bin/env bash
#
# build-dmg.sh
#
# Build a styled, distributable DMG for FocusDex from a built .app bundle.
#
# Usage:
#   ./scripts/build-dmg.sh [path/to/FocusDex.app]
#
# If no path is given, defaults to the Release build product produced by
# scripts/build.sh under build/DerivedData.
#

set -euo pipefail

# Resolve repo root (one directory above this script) so the script works
# regardless of where it is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Default .app location matches what Xcode emits with -derivedDataPath build/DerivedData.
DEFAULT_APP_PATH="${REPO_ROOT}/build/DerivedData/Build/Products/Release/FocusDex.app"
APP_PATH="${1:-${DEFAULT_APP_PATH}}"

# Normalize to an absolute path so later operations (cp, ln) are unambiguous.
if [[ "${APP_PATH}" != /* ]]; then
  APP_PATH="${REPO_ROOT}/${APP_PATH}"
fi

# Validate the .app bundle exists before doing anything destructive.
if [[ ! -d "${APP_PATH}" ]]; then
  echo "error: .app bundle not found at: ${APP_PATH}" >&2
  echo "hint: run scripts/build.sh first, or pass the .app path as the first argument." >&2
  exit 1
fi

# Staging and output locations live under build/ so they are easy to .gitignore
# and to clean between runs.
BUILD_DIR="${REPO_ROOT}/build"
STAGING_DIR="${BUILD_DIR}/dmg-staging"
DMG_PATH="${BUILD_DIR}/FocusDex.dmg"

# Recreate a clean staging directory so leftover files from a prior run can't
# leak into the DMG.
rm -rf "${STAGING_DIR}"
mkdir -p "${STAGING_DIR}"

# Copy the .app into staging (preserving symlinks, perms, and resource forks).
echo "Copying $(basename "${APP_PATH}") into staging..."
cp -R "${APP_PATH}" "${STAGING_DIR}/"

# Drop a symlink to /Applications next to the .app so users can drag-drop
# the app onto Applications from the mounted DMG window.
ln -s /Applications "${STAGING_DIR}/Applications"

# Remove any stale DMG at the output path (hdiutil's -ov flag also handles
# this, but being explicit keeps failures easier to diagnose).
rm -f "${DMG_PATH}"

# Build the compressed read-only DMG.
#   -volname     Mount-point/title shown in Finder
#   -srcfolder   Staging directory we just assembled
#   -ov          Overwrite the output file if it exists
#   -format UDZO zlib-compressed read-only image (good size/compat tradeoff)
#   -fs HFS+     HFS+ filesystem so symlinks and resource forks survive
echo "Creating DMG at ${DMG_PATH}..."
hdiutil create \
  -volname "FocusDex" \
  -srcfolder "${STAGING_DIR}" \
  -ov \
  -format UDZO \
  -fs HFS+ \
  "${DMG_PATH}"

# Report final artifact path and size (human-readable) so callers/CI can log it.
DMG_SIZE="$(du -h "${DMG_PATH}" | cut -f1)"
echo ""
echo "DMG built: ${DMG_PATH} (${DMG_SIZE})"
