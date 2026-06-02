#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/DrinkMore.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

cd "$ROOT_DIR"
rm -rf "$DIST_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

swift build -c release

cp ".build/release/DrinkMore" "$MACOS_DIR/DrinkMore"
cp "Assets/DrinkMore.icns" "$RESOURCES_DIR/DrinkMore.icns"
cat > "$CONTENTS_DIR/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>DrinkMore</string>
  <key>CFBundleIdentifier</key>
  <string>dev.drinkmore.app</string>
  <key>CFBundleName</key>
  <string>DrinkMore</string>
  <key>CFBundleDisplayName</key>
  <string>DrinkMore</string>
  <key>CFBundleIconFile</key>
  <string>DrinkMore.icns</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>0.1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>14.0</string>
  <key>LSApplicationCategoryType</key>
  <string>public.app-category.lifestyle</string>
  <key>NSHumanReadableCopyright</key>
  <string>Open source</string>
</dict>
</plist>
PLIST

chmod +x "$MACOS_DIR/DrinkMore"

(
  cd "$DIST_DIR"
  zip -qry "DrinkMore-macOS.zip" "DrinkMore.app"
)

echo "Created $APP_DIR"
echo "Created $DIST_DIR/DrinkMore-macOS.zip"
