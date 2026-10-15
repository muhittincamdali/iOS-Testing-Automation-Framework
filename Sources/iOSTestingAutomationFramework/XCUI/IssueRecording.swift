#if canImport(XCTest)
import XCTest
#if canImport(Testing)
import Testing
#endif

/// Where an assertion was written. Public functions take `#fileID`, `#filePath`, `#line` and
/// `#column` as default arguments (only direct defaults expand at the caller) and pass them on
/// in one value.
struct CallSite: Sendable {
    let fileID: String
    let filePath: StaticString
    let line: UInt
    let column: UInt
}

/// Reports a failure to Swift Testing when a Swift Testing test is running, and to XCTest
/// otherwise. Registered secrets are masked first.
func recordFailure(_ message: String, at site: CallSite) {
    let message = TestingAutomation.redactor.redact(message)
    #if canImport(Testing)
    if Test.current != nil {
        let location = SourceLocation(
            fileID: site.fileID,
            filePath: "\(site.filePath)",
            line: Int(site.line),
            column: Int(site.column)
        )
        Issue.record(Comment(rawValue: message), sourceLocation: location)
        return
    }
    #endif
    XCTFail(message, file: site.filePath, line: site.line)
}

/// Adds PNG images to the XCTest activity log, where Xcode and `xcresulttool` show them.
/// Swift Testing runs keep the files on disk instead; their paths are in the failure message.
@MainActor
func attachImages(_ images: [(name: String, bitmap: Bitmap)], activity: String) {
    #if canImport(Testing)
    if Test.current != nil { return }
    #endif
    XCTContext.runActivity(named: activity) { activity in
        for image in images {
            guard let data = try? image.bitmap.pngData() else { continue }
            let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.png")
            attachment.name = image.name
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
}
#endif
