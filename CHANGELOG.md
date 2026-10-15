# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 2.0.0 - 2026-10-15

A rebuilt package. In June 2026 the 1.0.0 sources were replaced with placeholder code (a visual
regression engine that compared nothing, an accessibility auditor that only printed), and the
test target no longer compiled. This release rebuilds the framework with tested rules behind
every UI helper, and merges the useful parts of iOSTestingTools, which is being archived.

### Added

- XCUITest layer: `Robot` actions that wait until an element is hittable, run as named XCTest
  activities and report failures at the caller's line (`tap`, `type`, `typeSecret`,
  `clearText`, `step`, `assertExists`, `assertNotExists`, `assertLabel`, `assertValue`);
  `XCUIElement.waitForHittable`, `waitForDisappearance`, `waitForLabel` and `waitForValue`;
  `XCUIElement.descriptors()`, one snapshot of the element tree as plain values.
- Self-healing lookups: `Locator`, `XCUIElement.element(_:timeout:healer:)` and
  `LocatorHealer`, which falls back to the label, the placeholder or the most similar
  identifier, refuses to guess between equal candidates, and records each healed lookup with
  the fix in `HealingLog`.
- Accessibility: `AccessibilityAudit` (missing labels, unlabeled images, touch targets below
  44 × 44 pt, labels that repeat the element kind, duplicate identifiers),
  `XCUIElement.accessibilityIssues()`, `Robot.assertAccessible()` with Apple's
  `performAccessibilityAudit()` as an option, and `ContrastRatio` for WCAG 2 ratios.
- Visual testing: `Bitmap`, `PixelRect`, `ImageComparator` (pixel tolerance, allowed share of
  changed pixels, ignored regions, difference image), `SnapshotStore` with the record modes
  `never`, `missing` and `all` (also set by `TESTING_AUTOMATION_RECORD`),
  `assertSnapshot(of:)` for SwiftUI views and bitmaps, `ViewRenderer`, and
  `Robot.assertScreenshot(named:of:ignoring:)` with the baseline, actual and difference images
  attached to the test report.
- Reports: `TestReport` (JUnit XML and a Markdown summary), `TestResultCollector`, which writes
  both for an XCTest bundle to `TESTING_AUTOMATION_REPORT_DIR`, `Redactor` and
  `TestingAutomation.registerSecret(_:)`.
- Resilience: `Wait.until` and `Wait.value` for polling in unit tests, `RetryPolicy` with
  constant or exponential backoff and jitter, and `FlakinessAnalyzer` for results from several
  CI runs.
- From iOSTestingTools: `Spy` and `ThrowingSpy` (typed test doubles), `Benchmark` with median,
  p95 and standard deviation, and the SwiftUI renderer; new `Fixtures` and
  `SeededRandomNumberGenerator` for reproducible test data.
- `TestResult` gains `suite` and `attempts`; results stored by 1.0.0 still decode.
- The AutomationShowcase example app with UI tests for every feature above, a DocC catalog with
  four articles, and CI that runs the package tests on macOS and an iPhone simulator and the
  example app's UI tests.

### Changed

- Requires iOS 17 or macOS 14, Swift 6.2 tools and the Swift 6 language mode (1.0.0 declared
  iOS 15, macOS 12, watchOS 8 and tvOS 15).
- The `Robot` API of 1.0.0 is kept (`init(app:)`, `tap(_:timeout:)`, `type(_:into:)`,
  `XCUIApplication.on(_:)`); `timeout` is now optional and defaults to `defaultTimeout`.
- `TestResult` stores negative, NaN and infinite durations as 0.

### Removed

- `SelfHealingEngine.findHealedElement(in:primaryID:fallbackLabel:timeout:)`: use
  `app.element(Locator(id, label: label))`.
- `VisualRegressionEngine.captureScreenshot(named:)` and `verifyVisualState(named:tolerance:)`,
  which compared nothing: use `Robot.assertScreenshot(named:)` or `assertSnapshot(of:named:)`.
- `AccessibilityAuditor.auditCurrentScreen()`, which only printed: use
  `Robot.assertAccessible()` or `XCUIElement.accessibilityIssues()`.
- The `iOSTestingAutomationFramework` singleton class and its error type, the swift-log
  dependency, the CocoaPods spec (never published to trunk) and the Documentation folder that
  described APIs the package did not have.

### Security

- Snapshot names become safe file names, so a name cannot write outside the baseline folder.
- PNG baselines are checked against a 50-million-pixel limit from their header before they are
  decoded; image sizes use overflow-checked arithmetic.
- Conversions from floating-point frames, timeouts and durations reject or clamp NaN, infinite
  and out-of-range values instead of trapping.
- Spies, the healing log, the audit's ancestor tracking and edit-distance work have fixed upper
  bounds.
- Decoding `SampleStatistics` goes through its validating initializer and recomputes the
  statistics from the measurements, so data without a finite measurement throws instead of
  making `percentile(_:)` crash.
- Typed secrets and credential patterns are masked in activity names, failure messages,
  `junit.xml` and `summary.md`, including the healed-locator suggestions. A secret is also found where a URL or form encoder
  percent-encoded it (hex in either case), where it was JSON-escaped (also as `\u00e4`), in
  composed and decomposed Unicode, and where it overlaps another secret. A quoted credential
  value is masked up to its closing quote.

## [1.0.0] - 2026-02-02

First tagged release, with a README-driven feature list. Its sources were replaced with
placeholder code in June 2026 and it is not maintained; see 2.0.0.

[Unreleased]: https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases/tag/v1.0.0
