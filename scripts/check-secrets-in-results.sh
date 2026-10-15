#!/usr/bin/env bash
# Fails if a password used by the example app's UI tests appears in the result bundle (every
# activity title and failure message, which is what Xcode and the xcodebuild log show) or in
# the reports TestResultCollector wrote.
#
# Usage: scripts/check-secrets-in-results.sh <result bundle> <report folder> <secret>...
#
# XCTest shortens long typed text in its activity titles ("Type 'correct-horse-batt...'"), so
# each secret is searched for by its first 12 characters as well as in full.
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 <result bundle> <report folder> <secret>..." >&2
  exit 2
fi

bundle=$1
reports=$2
shift 2
if [ ! -d "$reports" ]; then
  echo "::error::Report folder $reports does not exist"
  exit 1
fi

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

xcrun xcresulttool get test-results tests --path "$bundle" > "$workdir/tests.json"
test_ids=$(jq -r '.. | objects | select(.nodeType? == "Test Case") | .nodeIdentifier' "$workdir/tests.json")
if [ -z "$test_ids" ]; then
  echo "::error::No tests found in $bundle"
  exit 1
fi

count=0
while IFS= read -r test_id; do
  count=$((count + 1))
  xcrun xcresulttool get test-results activities --path "$bundle" --test-id "$test_id" > "$workdir/activities-$count.json"
  xcrun xcresulttool get test-results test-details --path "$bundle" --test-id "$test_id" > "$workdir/details-$count.json"
done <<< "$test_ids"

leaks=0
for secret in "$@"; do
  prefix=${secret:0:12}
  for needle in "$secret" "$prefix"; do
    if grep -rlF -- "$needle" "$workdir" "$reports" > "$workdir/hits.txt" 2>/dev/null; then
      echo "::error::A password used by the UI tests (starting with \"${secret:0:2}\") appears in:"
      sed -e "s|$workdir/||" "$workdir/hits.txt"
      leaks=1
      break
    fi
  done
done

if [ "$leaks" -ne 0 ]; then
  exit 1
fi
echo "Checked the activities and failures of $count tests and the reports in $reports: no password found."
