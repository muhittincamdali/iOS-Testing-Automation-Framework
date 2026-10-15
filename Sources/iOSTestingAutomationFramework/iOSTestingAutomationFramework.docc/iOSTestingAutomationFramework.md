# ``iOSTestingAutomationFramework``

Robots, self-healing locators, accessibility audits, screenshot comparison and CI reports for XCUITest, plus snapshot, wait, spy and fixture helpers for unit tests.

## Overview

iOSTestingAutomationFramework is a Swift package with no dependencies for iOS 17 and macOS 14.
Add it to your test targets, not to your app.

It has two layers:

- **XCUITest helpers** for UI test bundles: a ``Robot`` base class for one-robot-per-screen
  tests, element lookups that heal when an accessibility identifier changes, waits for
  hittable or vanished elements, an accessibility audit, screenshot comparison with ignored
  regions, and ``TestResultCollector``, which writes JUnit XML and a Markdown summary.
- **Plain-Swift helpers** that work in any test, Swift Testing or XCTest: SwiftUI snapshots
  with ``assertSnapshot(of:named:size:scale:colorScheme:background:comparator:store:filePath:)``,
  polling with ``Wait``, retries with ``RetryPolicy``, test doubles with ``Spy`` and
  ``ThrowingSpy``, reproducible data with ``Fixtures`` and timing with ``Benchmark``.

The rules behind the UI helpers (``LocatorHealer``, ``AccessibilityAudit``,
``ImageComparator``, ``TestReport``) work on plain values, so they are covered by unit tests
and can be used on their own.

```swift
import XCTest
import iOSTestingAutomationFramework

final class CheckoutTests: XCTestCase {
    @MainActor
    func testSignIn() {
        let app = XCUIApplication()
        app.launch()
        app.on(SignInRobot.self)
            .signIn(email: "ada@example.com", password: "correct-horse-battery")
            .assertCart(contains: 0)
    }
}
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:WritingUITestsWithRobots>
- <doc:ComparingScreenshots>
- <doc:ReportingOnCI>

### UI tests

- ``Robot``
- ``Locator``
- ``LocatorHealer``
- ``HealingLog``
- ``ElementDescriptor``
- ``ElementKind``
- ``TestResultCollector``

### Accessibility

- ``AccessibilityAudit``
- ``ContrastRatio``

### Images and snapshots

- ``assertSnapshot(of:named:size:scale:colorScheme:background:comparator:store:filePath:)``
- ``assertSnapshot(of:named:comparator:store:filePath:)``
- ``SnapshotError``
- ``SnapshotStore``
- ``ImageComparator``
- ``ImageComparison``
- ``Bitmap``
- ``PixelRect``
- ``ViewRenderer``

### Waiting and retrying

- ``Wait``
- ``RetryPolicy``
- ``FlakinessAnalyzer``

### Test doubles and data

- ``Spy``
- ``ThrowingSpy``
- ``Fixtures``
- ``SeededRandomNumberGenerator``

### Performance

- ``Benchmark``
- ``BenchmarkResult``
- ``SampleStatistics``

### Results and reports

- ``TestResult``
- ``TestStatus``
- ``TestReport``
- ``Redactor``
- ``TestingAutomation``
