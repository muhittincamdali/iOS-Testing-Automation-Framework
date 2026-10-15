# Reporting on CI

Write JUnit XML and Markdown summaries, keep secrets out of them, and find flaky tests.

## Collect results from a UI test bundle

``TestResultCollector`` observes every test in the bundle. Install it once, for example in
the class `setUp()` of a shared base class:

```swift
class AppUITestCase: XCTestCase {
    override class func setUp() {
        super.setUp()
        TestResultCollector.install(reportName: "App UI tests")
    }
}
```

Name a folder in `TESTING_AUTOMATION_REPORT_DIR`. With `xcodebuild`, add the `TEST_RUNNER_`
prefix so the variable reaches the test runner:

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme App -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

The folder then holds `junit.xml`, which Jenkins, GitLab, Buildkite and most test-report
actions read, and `summary.md`. On GitHub Actions, append the summary to the job summary:

```sh
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"
```

The files are rewritten after every test. If Xcode runs the tests in parallel, each runner
process has its own collector; install it with `perProcessFileNames: true` so each writes
`junit-<process id>.xml` instead of replacing the others' files.

## Build reports yourself

``TestReport`` turns any list of ``TestResult`` values into JUnit XML or Markdown:

```swift
let report = TestReport(name: "Nightly", results: results)
try report.junitXML().write(to: url, atomically: true, encoding: .utf8)
```

Names and messages are escaped for XML, characters that XML 1.0 does not allow are dropped,
and durations never print as `nan` or a negative number, so the file always parses.

## Keep secrets out of reports

Every report and robot message passes through a ``Redactor``. It masks:

- secrets registered with ``TestingAutomation/registerSecret(_:)`` (``Robot`` registers
  everything typed with `typeSecret(_:into:)`), also where they were percent-encoded (by
  `URLComponents`, `addingPercentEncoding` with any URL character set, or form encoding with
  `+` for a space; hex in either case) or JSON-escaped, including `\u00e4` escapes;
- values after `password=`, `token:`, `api_key=`, `secret=` and similar keys, and the token
  after `Bearer`.

Overlapping matches are merged before masking, so no part of a secret stays visible.

## Find flaky tests

Store each run's results as JSON (``TestResult`` is `Codable`) and analyze the last runs:

```swift
let history: [TestResult] = try loadLastTwentyRuns()
for entry in FlakinessAnalyzer().analyze(history) where entry.classification == .flaky {
    print(entry.suite, entry.name, entry.passRate ?? 0, entry.flips)
}
```

A test is flaky when it both passed and failed in the window, or passed only after a retry.
Use ``RetryPolicy`` for steps that depend on something outside the test, such as a server
warming up, and let the analyzer show which tests only pass because of it.
