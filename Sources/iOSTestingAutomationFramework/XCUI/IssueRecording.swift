#if canImport(XCTest)
import XCTest

/// Where an assertion was written. Public functions take `#fileID`, `#filePath`, `#line` and
/// `#column` as default arguments (only direct defaults expand at the caller) and pass them on
/// in one value.
struct CallSite: Sendable {
    let fileID: String
    let filePath: StaticString
    let line: UInt
    let column: UInt
}

/// Reports a failure to XCTest at the caller's line, with registered secrets masked.
///
/// The package does not import Swift Testing: UI test bundles cannot load it, and anything
/// that imports this package would inherit the dependency. Robots only run in XCTest UI tests;
/// the assertions meant for unit tests throw instead, which both frameworks report.
func recordFailure(_ message: String, at site: CallSite) {
    XCTFail(TestingAutomation.redactor.redact(message), file: site.filePath, line: site.line)
}
#endif
