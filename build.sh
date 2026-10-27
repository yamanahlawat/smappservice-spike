#!/usr/bin/env bash
# Build Spike-<variant>.app: a main app that registers one bundled launch agent.
# Usage: build.sh <variant> <out dir>
set -euo pipefail

variant="$1"
out="$2"
here="$(cd "$(dirname "$0")" && pwd)"
app="$out/Spike-$variant.app"
id="com.yamanahlawat.spike.$variant"

rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Library/LaunchAgents"

swiftc -O -o "$app/Contents/MacOS/Spike" "$here/src/Spike.swift"
swiftc -O -o "$app/Contents/MacOS/SpikeAgent" "$here/src/SpikeAgent.swift"

cat >"$app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIdentifier</key><string>$id</string>
  <key>CFBundleName</key><string>Spike-$variant</string>
  <key>CFBundleExecutable</key><string>Spike</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>LSUIElement</key><true/>
</dict>
</plist>
EOF

cat >"$app/Contents/Library/LaunchAgents/agent.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$id.agent</string>
  <key>BundleProgram</key><string>Contents/MacOS/SpikeAgent</string>
  <key>AssociatedBundleIdentifiers</key><array><string>$id</string></array>
  <key>RunAtLoad</key><true/>
  <key>EnvironmentVariables</key><dict><key>SPIKE_VARIANT</key><string>$variant</string></dict>
</dict>
</plist>
EOF

echo "$app"
