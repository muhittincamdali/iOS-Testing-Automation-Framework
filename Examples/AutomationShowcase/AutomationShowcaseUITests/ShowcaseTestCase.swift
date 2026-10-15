import XCTest
import iOSTestingAutomationFramework

/// Shared setup: one collector for the whole bundle and a fresh app for each test.
@MainActor
class ShowcaseTestCase: XCTestCase {
    static let email = "ada@example.com"
    static let password = "correct-horse-battery"

    var app: XCUIApplication!

    nonisolated override class func setUp() {
        super.setUp()
        // Writes junit.xml and summary.md when TESTING_AUTOMATION_REPORT_DIR is set.
        TestResultCollector.install(reportName: "AutomationShowcase UI tests")
    }

    override func setUp() async throws {
        // Robots report a failed step and carry on, so one run shows every problem in a flow.
        continueAfterFailure = true
        app = XCUIApplication()
        app.launchArguments += ["-frozenClock"]
    }

    func launch(_ arguments: [String] = []) {
        app.launchArguments += arguments
        app.launch()
    }

    func signIn() -> CatalogRobot {
        app.on(SignInRobot.self).signIn(email: Self.email, password: Self.password)
    }
}
