<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/banner-light.svg" alt="iOS Testing Automation: Robots, self-healing locators, screenshot diffs, accessibility audits and CI reports for XCUITest."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-version-light.svg" alt="Latest version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-platforms-light.svg" alt="Supported platforms: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-language-light.svg" alt="Language version: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/badge-license-light.svg" alt="License: MIT"></picture></a>
</p>

<p align="center">
<a href="#quick-start"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-start-en-light.svg" alt="Get started"></picture></a>
<a href="https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-docs-en-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/iOS-Testing-Automation-Framework/main/.github/brand/button-examples-en-light.svg" alt="Examples"></picture></a>
</p>

<!-- brand:end -->

A Swift package for UI tests and unit tests of iOS and macOS apps. In XCUITest it adds robots
(one class per screen whose methods wait, log a step and report failures at your line), element
lookups that still work after an accessibility identifier changes, an accessibility audit,
screenshot comparison with a difference image, and JUnit and Markdown reports for CI. In any
test, Swift Testing or XCTest, it adds SwiftUI snapshots, polling waits, retries, spies and
seeded test data. It is for teams whose UI tests break on small UI changes or are hard to read
in a CI log. The package has no dependencies and goes in your test targets only.

## Highlights

- **Readable UI tests** — robots turn `app.buttons["signIn.submit"].tap()` sequences into
  `app.on(SignInRobot.self).signIn(email:password:)`. Every step waits until its element can be
  tapped and shows up as a named step in Xcode's test report.
- **Locators that heal** — when an identifier is renamed, the lookup finds the element by its
  label, placeholder or a similar identifier, logs the fix to make, and refuses to guess when two
  elements match equally well.
- **Visual regressions you can see** — screenshots and SwiftUI views are compared with a
  baseline PNG, with a tolerance, ignored regions (a clock, a date) and a difference image in
  which every changed pixel is blue.
- **Accessibility in every run** — one call checks the screen for unlabeled controls, touch
  targets below 44 × 44 points, labels that repeat the element kind and duplicate identifiers,
  and can add Apple's `performAccessibilityAudit()`.
- **CI-ready output** — `junit.xml` and a Markdown job summary for each test bundle, with typed
  passwords and tokens masked, plus a flaky-test analysis over several runs.
- **Tested rules** — the healer, the audit, the image comparison, the reports and the redaction
  are plain Swift, covered by 111 Swift Testing tests on macOS and an iPhone simulator; 9 UI tests
  in the [example app](Examples/AutomationShowcase) run the XCUITest layer end to end on CI.

### What's included

| Area | Types |
| --- | --- |
| UI tests | `Robot`, `Locator`, `LocatorHealer`, `HealingLog`, `XCUIElement.element(_:)`, `waitForHittable`, `waitForDisappearance`, `waitForLabel`, `waitForValue`, `descriptors()` |
| Accessibility | `AccessibilityAudit`, `Robot.assertAccessible()`, `XCUIElement.accessibilityIssues()`, `ContrastRatio` |
| Images | `assertSnapshot(of:)`, `Robot.assertScreenshot(named:)`, `SnapshotStore`, `ImageComparator`, `Bitmap`, `ViewRenderer` |
| Reports | `TestResultCollector`, `TestReport` (JUnit XML, Markdown), `TestResult`, `Redactor`, `FlakinessAnalyzer` |
| Unit-test helpers | `Wait`, `RetryPolicy`, `Spy`, `ThrowingSpy`, `Fixtures`, `Benchmark` |

## Quick start

**1. Add the package**

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

Paste it into the search field at the top right of the window. Leave **Dependency Rule** at
**Up to Next Major Version** from `2.0.0`, then click **Add Package**. In the next window, choose
your **UI test target** next to **iOSTestingAutomationFramework** (not the app target: the
package links XCTest) and click **Add Package** again.

No UI test target yet? Choose **File › New › Target… › UI Testing Bundle**.

**2. Import the module**

```swift
import iOSTestingAutomationFramework
```

Put this line at the top of your UI test file, below `import XCTest`.

**3. Use it**

In a new Xcode app (**File › New › Project… › App**, with **Include Tests** checked), replace
everything in `ContentView.swift` with:

```swift
import SwiftUI

struct ContentView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Tapped \(count) times")
                .accessibilityIdentifier("counter.label")
            Button("Tap me") { count += 1 }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("counter.button")
        }
    }
}
```

Then replace the contents of the UI test file (the one ending in `UITests.swift`) with:

```swift
import XCTest
import iOSTestingAutomationFramework

final class CounterRobot: Robot {
    var label: XCUIElement { app.staticTexts["counter.label"] }
    var button: XCUIElement { app.buttons["counter.button"] }
}

final class CounterUITests: XCTestCase {
    @MainActor
    func testTappingCounts() {
        let app = XCUIApplication()
        app.launch()

        let counter = app.on(CounterRobot.self)
        counter
            .tap(counter.button)
            .tap(counter.button)
            .assertLabel(of: counter.label, equals: "Tapped 2 times")
    }
}
```

Press **⌘U**. The test launches the app on the simulator, taps the button twice and passes. In
the test report, each tap and the label check appear as their own step.

## Installation

### Swift Package Manager

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git
```

In a `Package.swift`, add the dependency and list the product under your test targets:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git", from: "2.0.0")
],
targets: [
    .testTarget(name: "YourAppTests", dependencies: [
        .product(name: "iOSTestingAutomationFramework", package: "iOS-Testing-Automation-Framework")
    ])
]
```

## Usage

The UI-test samples come from the [example app's UI tests](Examples/AutomationShowcase/AutomationShowcaseUITests)
and the unit-test samples from
[`ReadmeExamples.swift`](Tests/iOSTestingAutomationFrameworkTests/ReadmeExamples.swift); CI runs
both.

### Write a robot for each screen

```swift
final class SignInRobot: Robot {
    var email: XCUIElement { app.textFields["signIn.email"] }
    var password: XCUIElement { app.secureTextFields["signIn.password"] }
    var submit: XCUIElement { app.element(Locator("signIn.submit", label: "Sign In", kind: .button)) }
    var error: XCUIElement { app.staticTexts["signIn.error"] }

    @discardableResult
    func signIn(email address: String, password secret: String) -> CatalogRobot {
        type(address, into: email)
        typeSecret(secret, into: password)
        tap(submit)
        return on(CatalogRobot.self)
    }
}
```

Tests then read like the steps of a test case:

```swift
app.on(SignInRobot.self)
    .signIn(email: "ada@example.com", password: "correct-horse-battery")
    .assertCart(contains: 0)
    .open("grinder")
    .addToCart(times: 2)
    .goBack()
    .assertCart(contains: 2)
```

`typeSecret(_:into:)` registers the password, so it is masked as `••••` in step names, failure
messages and reports.

### Keep tests working when an identifier changes

A `Locator` carries the identifier plus the label or placeholder a person sees. Here the test
still uses the identifier from before a redesign:

```swift
// "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
XCTAssertTrue(button.exists)
XCTAssertEqual(button.identifier, "signIn.submit")
```

The healed lookup is logged in `HealingLog` and in the Markdown report, with the fix:
`Update the locator "loginButton" to "signIn.submit"`.

### Audit accessibility

```swift
app.on(SignInRobot.self).assertAccessible()
```

Each issue becomes a test failure. To inspect the issues yourself:

```swift
let issues = try app.accessibilityIssues()
let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
```

### Compare screenshots

`assertScreenshot(named:of:ignoring:)` compares the app (or one element) with a baseline PNG
stored in `__Snapshots__/` next to the test file, leaving out elements that change on their own:

```swift
catalog.assertScreenshot(named: "catalog", ignoring: [catalog.lastUpdated], comparator: comparator, store: store)
```

The first run records the baseline and fails, so a missing baseline never passes silently. On a
mismatch, the baseline, the actual screenshot and the difference image are attached to the test
report.

### Snapshot a SwiftUI view in a unit test

```swift
@Test @MainActor func signalBarsLookRight() throws {
    try assertSnapshot(of: SignalBars(level: 3), named: "signal-bars-3", size: CGSize(width: 44, height: 32))
}
```

`assertSnapshot` throws instead of recording an issue, so it works the same in Swift Testing and
XCTest.

### Wait for asynchronous state and check a fake

```swift
struct FakeUserService: UserService {
    let fetchUser = ThrowingSpy<Int, String>(returning: "Ada")

    func user(id: Int) async throws -> String {
        try fetchUser(id)
    }
}

@Test @MainActor func profileLoadsTheUser() async throws {
    let service = FakeUserService()
    let model = ProfileModel(service: service)

    model.load(id: 42)

    try await Wait.until("the name to load") { model.name == "Ada" }
    #expect(service.fetchUser.inputs == [42])
}
```

### Report results on CI

Install the collector once in your UI test bundle:

```swift
override class func setUp() {
    super.setUp()
    // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
    TestResultCollector.install(reportName: "AutomationShowcase UI tests")
}
```

and name the report folder when you run the tests:

```sh
TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR="$PWD/reports" xcodebuild test \
  -scheme AutomationShowcase -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cat reports/summary.md >> "$GITHUB_STEP_SUMMARY"   # on GitHub Actions
```

To build a report from your own results:

```swift
let report = TestReport(name: "Nightly", results: results)
let xml = report.junitXML()
```

## Demo

The [AutomationShowcase](Examples/AutomationShowcase) app on an iPhone 17 Pro simulator. Its
visual regression test hides the prices and compares the screen with the baseline; the third
image is the difference image the package drew, with every changed pixel in blue. The images
are saved by that test and scaled by
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/visual-diff-dark.png"><img src="docs/images/visual-diff-light.png" alt="Three phone screenshots side by side: the catalog with prices, the catalog with the prices hidden, and a faded difference image in which only the prices and the switch are highlighted in blue" width="840"></picture></p>

To run the UI tests yourself, open `AutomationShowcase.xcodeproj` in
[`Examples/AutomationShowcase`](Examples/AutomationShowcase), choose an iPhone simulator and press
**⌘U**. [Examples/README.md](Examples/README.md) lists what each test shows.

## Documentation

Reference documentation and articles:

- [API reference](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/)
  (DocC, published to GitHub Pages from `main`)
- Build it locally in Xcode with **Product › Build Documentation**, or from the command line:

```sh
xcodebuild docbuild -scheme iOSTestingAutomationFramework -destination 'generic/platform=iOS Simulator'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/gettingstarted)
  — add the package to test targets, write a first robot test and a first unit test
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/GettingStarted.md)).
- [Writing UI Tests with Robots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/writinguitestswithrobots)
  — robot chains, healing locators, waits and the accessibility audit
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/WritingUITestsWithRobots.md)).
- [Comparing Screenshots](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/comparingscreenshots)
  — SwiftUI snapshots, UI-test screenshots, tolerances and record modes
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ComparingScreenshots.md)).
- [Reporting on CI](https://muhittincamdali.github.io/iOS-Testing-Automation-Framework/documentation/iostestingautomationframework/reportingonci)
  — JUnit XML, job summaries, redaction and flaky tests
  ([source](Sources/iOSTestingAutomationFramework/iOSTestingAutomationFramework.docc/ReportingOnCI.md)).

## Requirements

| Platform  | Minimum version       |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.2 · Xcode 26+ |

The XCUITest helpers need a UI test target; the other helpers work in any test target. CI builds
with the default Xcode of GitHub's `macos-26` runner image. The package is developed with
Xcode 27.

## Architecture

- `Sources/iOSTestingAutomationFramework/` has one folder per area: `Core`, `Reporting`,
  `Waiting`, `Resilience`, `Locators`, `Accessibility`, `Visual`, `Doubles`, `Fixtures`,
  `Performance` and `XCUI`.
- Everything outside `XCUI` is plain Swift. The rules (healing, the audit, image comparison,
  reports, redaction) work on values such as `ElementDescriptor` and `Bitmap`, so unit tests
  cover them without a running app. `XCUI` is a thin layer that turns one snapshot of the screen
  into descriptors and reports failures through XCTest.
- The package does not import Swift Testing: Xcode builds UI test bundles with Swift Testing
  unavailable, so a dependency on it would break every UI test target. Assertions meant for unit
  tests throw, which both frameworks report as a failure.
- Input from outside the test is bounded: image sizes are checked before decoding, snapshot names
  become safe file names, NaN and infinite numbers are clamped instead of converted, and every
  list that grows with input has a limit.
- CI runs `swift test` on macOS, `xcodebuild test` on an iPhone simulator, builds for iOS and
  macOS, runs the example app's UI tests and publishes the DocC documentation.

Run the tests locally:

```sh
swift test                                    # macOS
xcodebuild test -scheme iOSTestingAutomationFramework \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
cd Examples/AutomationShowcase                # the UI tests
xcodebuild test -scheme AutomationShowcase \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Roadmap

- Text and JSON snapshot strategies next to the image comparison.
- A perceptual color tolerance for screenshots taken on different machines.
- Add the package to the Swift Package Index; `.spi.yml` is already in the repository.

## Contributing

Contributions are welcome. Read the [contributing guide](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/CONTRIBUTING.md) and the [code of conduct](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) before opening a pull request. Report security issues privately as described in the [security policy](https://github.com/muhittincamdali/iOS-Testing-Automation-Framework/blob/main/SECURITY.md).

## License

Released under the MIT license. See [LICENSE](LICENSE).
