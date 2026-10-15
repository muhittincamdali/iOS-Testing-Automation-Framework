import XCTest
import iOSTestingAutomationFramework

// The README's Robot sample is copied from this file.

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

final class CatalogRobot: Robot {
    var cartCount: XCUIElement { app.staticTexts["cart.count"] }
    var showPrices: XCUIElement { app.switches["catalog.showPrices"] }
    var lastUpdated: XCUIElement { app.staticTexts["catalog.updated"] }

    func product(_ id: String) -> XCUIElement { app.buttons["product.\(id)"] }

    @discardableResult
    func open(_ id: String) -> ProductRobot {
        tap(product(id))
        return on(ProductRobot.self)
    }

    @discardableResult
    func assertCart(contains count: Int) -> Self {
        assertLabel(of: cartCount, equals: "Cart: \(count)")
    }
}

final class ProductRobot: Robot {
    var addToCart: XCUIElement { app.buttons["detail.addToCart"] }
    var back: XCUIElement { app.navigationBars.buttons.element(boundBy: 0) }

    @discardableResult
    func addToCart(times: Int = 1) -> Self {
        for _ in 0..<times { tap(addToCart) }
        return self
    }

    @discardableResult
    func goBack() -> CatalogRobot {
        tap(back)
        return on(CatalogRobot.self)
    }
}
