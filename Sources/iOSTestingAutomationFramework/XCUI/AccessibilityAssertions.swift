#if canImport(XCTest)
import XCTest

extension XCUIElement {
    /// Runs `audit` on this element and its descendants, as they are on screen now.
    @MainActor
    public func accessibilityIssues(audit: AccessibilityAudit = AccessibilityAudit()) throws -> [AccessibilityAudit.Issue] {
        audit.run(on: try descriptors())
    }
}

extension Robot {
    /// Fails once for every accessibility issue on the current screen.
    ///
    /// - Parameters:
    ///   - audit: The rules to check.
    ///   - identifiers: Elements with these identifiers are skipped, for example a system
    ///     control you cannot change.
    ///   - includingSystemAudit: Also runs Apple's `performAccessibilityAudit()`, which checks
    ///     contrast, Dynamic Type, clipped text and more, and reports its own failures.
    ///   - fileID: The file ID of the call, for the failure location. Leave the default.
    ///   - filePath: The file path of the call, for the failure location. Leave the default.
    ///   - line: The line of the call, for the failure location. Leave the default.
    ///   - column: The column of the call, for the failure location. Leave the default.
    @discardableResult
    public func assertAccessible(
        audit: AccessibilityAudit = AccessibilityAudit(),
        ignoring identifiers: Set<String> = [],
        includingSystemAudit: Bool = false,
        fileID: String = #fileID, filePath: StaticString = #filePath, line: UInt = #line, column: UInt = #column
    ) -> Self {
        let site = CallSite(fileID: fileID, filePath: filePath, line: line, column: column)
        XCTContext.runActivity(named: "Audit accessibility") { _ in
            do {
                let elements = try app.descriptors().filter { !identifiers.contains($0.identifier) }
                for issue in audit.run(on: elements) {
                    recordFailure("Accessibility: \(issue.message)", at: site)
                }
                if includingSystemAudit {
                    try app.performAccessibilityAudit()
                }
            } catch {
                recordFailure("The accessibility audit could not run: \(error)", at: site)
            }
        }
        return self
    }
}
#endif
