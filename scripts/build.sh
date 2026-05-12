#!/usr/bin/env bash
# FocusDex — build the Mac app via xcodegen + xcodebuild
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "→ xcodegen not found. Install with: brew install xcodegen"
  exit 1
fi

echo "→ Generating Xcode project from project.yml..."
xcodegen generate

echo "→ Building Release..."
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
echo ""
echo "✓ Built: $APP_PATH"
echo "  Run:    open \"$APP_PATH\""
