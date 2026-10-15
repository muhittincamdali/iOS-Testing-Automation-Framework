#if canImport(XCTest)
import XCTest

/// A base class for the Robot pattern: one robot per screen, with methods named after what a
/// person does there, so UI tests read like the steps of a test case.
///
/// ```swift
/// final class SignInRobot: Robot {
///     var email: XCUIElement { app.textFields["signIn.email"] }
///     var password: XCUIElement { app.secureTextFields["signIn.password"] }
///     var submit: XCUIElement { app.element(Locator("signIn.submit", label: "Sign In", kind: .button)) }
///
///     @discardableResult
///     func signIn(email address: String, password secret: String) -> CatalogRobot {
///         type(address, into: email)
///         typeSecret(secret, into: password)
///         tap(submit)
///         return on(CatalogRobot.self)
///     }
/// }
///
/// app.on(SignInRobot.self)
///     .signIn(email: "ada@example.com", password: "correct horse")
///     .assertProductsShown()
/// ```
///
/// Every action waits for its element first, records an XCTest activity (so the steps show
/// up in the test report) and reports failures at the line of your test.
@MainActor
open class Robot {
    public let app: XCUIApplication
    /// How long actions and assertions wait for an element unless told otherwise.
    open var defaultTimeout: TimeInterval { 5 }

    public required init(app: XCUIApplication) {
        self.app = app
    }

    /// Continues with the robot for the next screen.
    public func on<Next: Robot>(_ robot: Next.Type) -> Next {
        Next(app: app)
    }

    /// Groups the actions in `body` under one named activity in the test report.
    @discardableResult
    public func step(_ name: String, _ body: (Self) throws -> Void) rethrows -> Self {
        try XCTContext.runActivity(named: TestingAutomation.redactor.redact(name)) { _ in try body(self) }
        return self
    }

    // MARK: - Actions

    /// Waits for `element` to be hittable and taps it.
    @discardableResult
    public func tap(
        _ element: XCUIElement,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Tap \(element.shortDescription)") {
            guard waitUntilHittable(element, timeout: timeout, action: "tap", at: site) else { return }
            element.tap()
        }
        return self
    }

    /// Finds the element with `locator` (healing the lookup if needed) and taps it.
    @discardableResult
    public func tap(
        _ locator: Locator,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let element = app.element(locator, timeout: timeout ?? defaultTimeout)
        return tap(element, timeout: timeout, fileID: fileID, filePath: filePath, line: line, column: column)
    }

    /// Taps `element` and types `text` into it. The text appears in the test report.
    @discardableResult
    public func type(
        _ text: String,
        into element: XCUIElement,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Type \"\(text)\" into \(element.shortDescription)") {
            enter(text, into: element, timeout: timeout, at: site)
        }
        return self
    }

    /// Enters a password or token. The text is registered with
    /// ``TestingAutomation/registerSecret(_:)`` first, so it is masked in activity names,
    /// failure messages and reports.
    ///
    /// On iOS and macOS the text is pasted (⌘V) instead of typed, because XCTest names its own
    /// typing activity after the typed text, and that name reaches the test log and the result
    /// bundle. The text goes on the pasteboard for this device only and the pasteboard is
    /// emptied after the paste; what was on it before is not restored. On other platforms the
    /// text is typed, and XCTest's own activity shows its first characters.
    @discardableResult
    public func typeSecret(
        _ text: String,
        into element: XCUIElement,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        TestingAutomation.registerSecret(text)
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Enter a secret into \(element.shortDescription)") {
            guard SecretPasteboard.isAvailable else {
                enter(text, into: element, timeout: timeout, at: site)
                return
            }
            guard waitUntilHittable(element, timeout: timeout, action: "enter a secret into", at: site) else { return }
            element.tap()
            if SecretPasteboard.paste(text, into: element, timeout: timeout ?? defaultTimeout) == false {
                recordFailure("Pasting a secret into \(element.shortDescription) did not change its value", at: site)
            }
        }
        return self
    }

    /// Deletes the text in a text field or text view.
    @discardableResult
    public func clearText(
        in element: XCUIElement,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Clear \(element.shortDescription)") {
            guard waitUntilHittable(element, timeout: timeout, action: "clear", at: site) else { return }
            element.tap()
            let length = (element.value as? String)?.count ?? 0
            // Bounded: a field never needs more deletes than its text has characters.
            if length > 0 {
                element.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: min(length, 10_000)))
            }
        }
        return self
    }

    // MARK: - Assertions

    /// Fails unless `element` exists within the timeout.
    @discardableResult
    public func assertExists(
        _ element: XCUIElement,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Expect \(element.shortDescription) to exist") {
            if !element.waitForExistence(timeout: XCUIElement.sanitizedTimeout(timeout ?? defaultTimeout)) {
                recordFailure("Expected \(element.shortDescription) to exist", at: site)
            }
        }
        return self
    }

    /// Fails unless `element` is gone within the timeout.
    @discardableResult
    public func assertNotExists(
        _ element: XCUIElement,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Expect \(element.shortDescription) not to exist") {
            if !element.waitForDisappearance(timeout: timeout ?? defaultTimeout) {
                recordFailure("Expected \(element.shortDescription) not to exist", at: site)
            }
        }
        return self
    }

    /// Fails unless `element`'s label becomes `expected` within the timeout.
    @discardableResult
    public func assertLabel(
        of element: XCUIElement,
        equals expected: String,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Expect the label of \(element.shortDescription) to be \"\(expected)\"") {
            if !element.waitForLabel(expected, timeout: timeout ?? defaultTimeout) {
                let actual = element.exists ? "\"\(element.label)\"" : "no element"
                recordFailure("Expected label \"\(expected)\" on \(element.shortDescription), found \(actual)", at: site)
            }
        }
        return self
    }

    /// Fails unless `element`'s value becomes `expected` within the timeout.
    @discardableResult
    public func assertValue(
        of element: XCUIElement,
        equals expected: String,
        timeout: TimeInterval? = nil,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        activity("Expect the value of \(element.shortDescription) to be \"\(expected)\"") {
            if !element.waitForValue(expected, timeout: timeout ?? defaultTimeout) {
                let actual = element.exists ? "\"\(element.value.map { "\($0)" } ?? "")\"" : "no element"
                recordFailure("Expected value \"\(expected)\" on \(element.shortDescription), found \(actual)", at: site)
            }
        }
        return self
    }

    // MARK: - Helpers

    private func activity(_ name: String, _ body: () -> Void) {
        XCTContext.runActivity(named: TestingAutomation.redactor.redact(name)) { _ in body() }
    }

    private func waitUntilHittable(_ element: XCUIElement, timeout: TimeInterval?, action: String, at site: CallSite) -> Bool {
        guard element.waitForHittable(timeout: timeout ?? defaultTimeout) else {
            let state = element.exists ? "exists but cannot be tapped" : "does not exist"
            recordFailure("Cannot \(action) \(element.shortDescription): it \(state)", at: site)
            return false
        }
        return true
    }

    private func enter(_ text: String, into element: XCUIElement, timeout: TimeInterval?, at site: CallSite) {
        guard waitUntilHittable(element, timeout: timeout, action: "type into", at: site) else { return }
        element.tap()
        element.typeText(text)
    }
}

extension XCUIApplication {
    /// Starts a robot chain on this application.
    @MainActor
    @discardableResult
    public func on<R: Robot>(_ robot: R.Type) -> R {
        R(app: self)
    }
}

extension XCUIElement {
    /// A short description for messages: the identifier, or the label, or the type.
    @MainActor
    var shortDescription: String {
        // Reading identifier or label of a missing element fails the test, so describe the
        // query instead.
        guard exists else { return description }
        if !identifier.isEmpty { return "\"\(identifier)\"" }
        if !label.isEmpty { return "\"\(label)\"" }
        return ElementKind(elementType).rawValue
    }
}
#endif
