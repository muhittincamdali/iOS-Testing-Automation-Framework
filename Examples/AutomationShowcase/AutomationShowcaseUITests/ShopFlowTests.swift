import XCTest
import iOSTestingAutomationFramework

final class ShopFlowTests: ShowcaseTestCase {
    @MainActor
    func testSignInAndFillTheCart() {
        launch()
        // The README's robot sample is this chain.
        app.on(SignInRobot.self)
            .signIn(email: "ada@example.com", password: "correct-horse-battery")
            .assertCart(contains: 0)
            .open("grinder")
            .addToCart(times: 2)
            .goBack()
            .assertCart(contains: 2)
    }

    @MainActor
    func testWrongPasswordShowsAnErrorAndKeepsThePasswordOutOfTheLog() {
        launch()
        let robot = app.on(SignInRobot.self)
        robot.signIn(email: Self.email, password: "not-the-password")
        robot.assertLabel(of: robot.error, equals: "Wrong email or password.")

        // typeSecret registered the password, so every message and report masks it, and
        // pasted it, so XCTest's own log of the step does not contain it either. CI checks the
        // result bundle and the reports with scripts/check-secrets-in-results.sh.
        XCTAssertEqual(TestingAutomation.redactor.redact("typed not-the-password"), "typed ••••")
    }

    @MainActor
    func testInvalidInputIsRejected() {
        launch()
        let robot = app.on(SignInRobot.self)
        robot.signIn(email: "ada", password: "short")
        robot.assertExists(robot.error)
            .assertNotExists(app.staticTexts["cart.count"], timeout: 1)
    }
}
