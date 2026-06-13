#if canImport(XCTest)
import XCTest

/// Base class for the Robot Pattern in UI Testing.
@MainActor
open class Robot {
    public let app: XCUIApplication
    
    public required init(app: XCUIApplication) {
        self.app = app
    }
    
    @discardableResult
    public func tap(_ element: XCUIElement, timeout: TimeInterval = 5.0) -> Self {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "Element not found: \(element.description)")
        element.tap()
        return self
    }
    
    @discardableResult
    public func type(_ text: String, into element: XCUIElement) -> Self {
        XCTAssertTrue(element.waitForExistence(timeout: 5.0))
        element.tap()
        element.typeText(text)
        return self
    }
}

public extension XCUIApplication {
    /// Entry point for the Robot Pattern.
    @discardableResult
    func on<T: Robot>(_ robotType: T.Type) -> T {
        return T(app: self)
    }
}
#endif
