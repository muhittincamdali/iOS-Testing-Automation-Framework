# Getting Started

Add the package to a test target and write a first UI test and a first unit test with it.

## Add the package

1. In Xcode, choose **File › Add Package Dependencies…** and enter
   `https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git`.
2. Keep **Up to Next Major Version** from `2.0.0` and click **Add Package**.
3. In the next window, choose your **UI test target** (and your unit test target if you want
   the unit-test helpers) next to **iOSTestingAutomationFramework**. Do not add it to the app
   target: the package links XCTest.

With a `Package.swift`, add the dependency and list the product under your test target:

```swift
.package(url: "https://github.com/muhittincamdali/iOS-Testing-Automation-Framework.git", from: "2.0.0")

.testTarget(
    name: "AppUITests",
    dependencies: [.product(name: "iOSTestingAutomationFramework", package: "iOS-Testing-Automation-Framework")]
)
```

## Give your views identifiers

UI tests find elements by accessibility identifier. Add one to every control a test touches:

```swift
Button("Sign In") { signIn() }
    .accessibilityIdentifier("signIn.submit")
```

A ``Locator`` can also carry the label a person sees, so the test still finds the button if
the identifier changes; see <doc:WritingUITestsWithRobots>.

## Write a UI test

Create one ``Robot`` subclass per screen, with the elements as properties and the actions as
methods. Each action waits for its element and reports failures at your test's line.

```swift
import XCTest
import iOSTestingAutomationFramework

final class SignInRobot: Robot {
    var email: XCUIElement { app.textFields["signIn.email"] }
    var password: XCUIElement { app.secureTextFields["signIn.password"] }
    var submit: XCUIElement { app.element(Locator("signIn.submit", label: "Sign In", kind: .button)) }

    @discardableResult
    func signIn(email address: String, password secret: String) -> CatalogRobot {
        type(address, into: email)
        typeSecret(secret, into: password)
        tap(submit)
        return on(CatalogRobot.self)
    }
}

final class SignInTests: XCTestCase {
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

`typeSecret(_:into:)` registers the password with ``TestingAutomation/registerSecret(_:)``, so
it is masked in the test report.

## Write a unit test

The plain-Swift helpers work in Swift Testing and XCTest. ``Wait`` polls until a condition
holds, and ``Spy`` records the calls to a fake:

```swift
import Testing
import iOSTestingAutomationFramework

@Test @MainActor func profileLoadsTheUser() async throws {
    let service = FakeUserService()
    let model = ProfileModel(service: service)

    model.load(id: 42)

    try await Wait.until("the name to load") { model.name == "Ada" }
    #expect(service.fetchUser.inputs == [42])
}
```

## Next steps

- <doc:ComparingScreenshots> for SwiftUI snapshots and screenshot baselines.
- <doc:ReportingOnCI> for JUnit XML, job summaries and flaky-test detection.
