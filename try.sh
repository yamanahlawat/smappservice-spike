#!/usr/bin/env bash
# Install Spike-<variant>.app in /Applications, register its agent, and report.
# Usage: try.sh <variant>
set -uo pipefail

variant="$1"
app="/Applications/Spike-$variant.app"
label="com.yamanahlawat.spike.$variant.agent"
marker="/tmp/spike-agent-$variant"
report="$RUNNER_TEMP/report-$variant.md"
rm -f "$marker"

{
  echo "### $variant"
  echo
  echo '```'
  echo "--- codesign"
  codesign -dvv "$app" 2>&1 | grep -E "^(Identifier|Authority|TeamIdentifier|Signature|CodeDirectory)" || true
  codesign --verify --strict --verbose=2 "$app" 2>&1 | tail -2 || true
  echo "--- gatekeeper"
  spctl -a -vv -t exec "$app" 2>&1 || true
  echo "--- register"
  "$app/Contents/MacOS/Spike" register agent.plist 2>&1
  sleep 5
  echo "--- status after 5s"
  "$app/Contents/MacOS/Spike" status agent.plist 2>&1
  echo "--- launchctl"
  launchctl print "gui/$(id -u)/$label" 2>&1 | grep -E "state =|pid =|last exit code|program|path =" | head -8 || echo "not loaded"
  echo "--- agent ran"
  if [ -f "$marker" ]; then cat "$marker"; else echo "no: $marker missing"; fi
  echo "--- unregister"
  "$app/Contents/MacOS/Spike" unregister agent.plist 2>&1
  echo '```'
  echo
} | tee "$report"
