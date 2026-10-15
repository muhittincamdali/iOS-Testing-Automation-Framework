import XCTest
import iOSTestingAutomationFramework

final class HealingAndAuditTests: ShowcaseTestCase {
    @MainActor
    func testAnOutdatedIdentifierIsHealedByItsLabel() throws {
        HealingLog.reset()
        launch()
        // "loginButton" was the identifier before the redesign; the app now uses "signIn.submit".
        let button = app.element(Locator("loginButton", label: "Sign In", kind: .button), timeout: 1)
        XCTAssertTrue(button.exists)
        XCTAssertEqual(button.identifier, "signIn.submit")

        let event = try XCTUnwrap(HealingLog.events.first)
        XCTAssertEqual(event.strategy, .label)
        XCTAssertEqual(event.element.identifier, "signIn.submit")
        XCTAssertTrue(event.suggestion.contains("signIn.submit"))
    }

    @MainActor
    func testAMissingElementIsNotHealedIntoTheWrongOne() {
        launch()
        let missing = app.element(Locator("checkout.pay", label: "Pay now", kind: .button), timeout: 0.5)
        XCTAssertFalse(missing.exists)
    }

    @MainActor
    func testSignInAndCatalogScreensPassTheAudit() {
        launch()
        app.on(SignInRobot.self).assertAccessible()
        signIn().assertAccessible()
    }

    @MainActor
    func testTheAuditFindsTheDeliberateMistakes() throws {
        launch(["-screen", "auditDemo"])
        XCTAssertTrue(app.staticTexts["audit.favorites"].waitForExistence(timeout: 5))
        let issues = try app.accessibilityIssues()
        let favoriteIssues = issues.filter { $0.element.identifier == "audit.favorite" }.map(\.rule)
        XCTAssertEqual(Set(favoriteIssues), [.missingLabel, .smallTouchTarget])
        XCTAssertEqual(issues.count, 2, "\(issues)")
    }
}
