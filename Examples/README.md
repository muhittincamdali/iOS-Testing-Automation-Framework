# Examples

## AutomationShowcase

A small iPhone shop app (sign in, a catalog, a product page and a cart) and the UI tests that
drive it with this package. It uses the package from this checkout (a local package reference
to `../..`), so it always tests the current code.

The UI tests show each part of the XCUITest layer on a real app:

| Test file                                                                                                 | What it shows                                                                                                                     |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [`Robots.swift`](AutomationShowcase/AutomationShowcaseUITests/Robots.swift)                               | One robot per screen: `SignInRobot`, `CatalogRobot`, `ProductRobot`                                                               |
| [`ShopFlowTests.swift`](AutomationShowcase/AutomationShowcaseUITests/ShopFlowTests.swift)                 | A sign-in and cart flow as one robot chain; a typed password masked in the report                                                 |
| [`HealingAndAuditTests.swift`](AutomationShowcase/AutomationShowcaseUITests/HealingAndAuditTests.swift)   | An outdated identifier healed by its label; the accessibility audit on clean screens and on a screen with two deliberate mistakes |
| [`VisualRegressionTests.swift`](AutomationShowcase/AutomationShowcaseUITests/VisualRegressionTests.swift) | A screenshot baseline, a passing comparison, and a change that the comparison catches, in light and dark appearance               |
| [`QuickStartTests.swift`](AutomationShowcase/AutomationShowcaseUITests/QuickStartTests.swift) | The README's quick start: a counter screen and its robot |
| [`ShowcaseTestCase.swift`](AutomationShowcase/AutomationShowcaseUITests/ShowcaseTestCase.swift)           | `TestResultCollector`, which writes `junit.xml` and `summary.md`                                                                  |

Run it:

1. Open `Examples/AutomationShowcase/AutomationShowcase.xcodeproj` in Xcode 26 or later.
2. Choose the **AutomationShowcase** scheme and an iPhone simulator.
3. Press **Test** (⌘U) to run the UI tests, or **Run** (⌘R) to use the app. The demo account
   is `ada@example.com` with the password `correct-horse-battery`.

From the command line, with the reports written to `reports/`:

```sh
cd Examples/AutomationShowcase
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

The project file is made with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from
[`project.yml`](AutomationShowcase/project.yml) and committed, so you only need XcodeGen after
editing `project.yml`.

## Unit-test samples

The README's unit-test samples (a SwiftUI snapshot, a polling wait with a spy, a retry policy,
fixtures and a JUnit report) are tests in
[`Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift`](../Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift),
which run with `swift test` on macOS and on an iPhone simulator.
