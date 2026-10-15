#!/usr/bin/env bash
# Produces the README and DocC images from the example app's UI tests.
#
# Every image is output of the package's own code: VisualRegressionTests in
# Examples/AutomationShowcase takes the catalog screenshots, hides the prices, compares the two
# with ImageComparator and saves the baseline, the changed screen and the difference image side
# by side. This script runs that test with a fixed status bar and scales the results.
#
# Usage: scripts/generate-screenshots.sh [simulator name or UDID]
# Without an argument it uses the first available iPhone simulator.
# Output: docs/images/ and the DocC catalog's Resources folder.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
device="${1:-}"
if [[ -z "$device" ]]; then
  device="$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')"
fi
if [[ -z "$device" ]]; then
  echo "No available iPhone simulator found." >&2
  exit 1
fi
destination="platform=iOS Simulator,name=$device"
if [[ "$device" =~ ^[0-9A-F-]{36}$ ]]; then
  destination="platform=iOS Simulator,id=$device"
fi

raw_dir="$(mktemp -d)"
trap 'rm -rf "$raw_dir"' EXIT
images_dir="$repo_root/docs/images"
docc_dir="$repo_root/Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/Resources"
mkdir -p "$images_dir" "$docc_dir"

xcrun simctl boot "$device" 2>/dev/null || true
xcrun simctl bootstatus "$device" -b >/dev/null
xcrun simctl status_bar "$device" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularBars 4 --wifiBars 3 --operatorName ""

echo "Running VisualRegressionTests on '$device'"
# Variables prefixed with TEST_RUNNER_ are passed to the UI test process without the prefix.
TEST_RUNNER_SCREENSHOT_DIR="$raw_dir" xcodebuild test \
  -project "$repo_root/Examples/AutomationShowcase/AutomationShowcase.xcodeproj" \
  -scheme AutomationShowcase \
  -destination "$destination" \
  -only-testing:AutomationShowcaseUITests/VisualRegressionTests \
  CODE_SIGNING_ALLOWED=NO -quiet

xcrun simctl status_bar "$device" clear

# The test already cut the screenshots to the top of the screen; scale them for the README.
for appearance in light dark; do
  catalog="$images_dir/catalog-$appearance.png"
  cp "$raw_dir/catalog-$appearance.png" "$catalog"
  sips --resampleWidth 603 "$catalog" >/dev/null

  diff="$images_dir/visual-diff-$appearance.png"
  cp "$raw_dir/visual-diff-$appearance.png" "$diff"
  sips --resampleWidth 1400 "$diff" >/dev/null
done

# DocC picks the dark variant from the "~dark" suffix.
cp "$images_dir/visual-diff-light.png" "$docc_dir/visual-diff-light.png"
cp "$images_dir/visual-diff-dark.png" "$docc_dir/visual-diff-light~dark.png"

ls -1 "$images_dir" "$docc_dir"
