#if canImport(XCTest)
import XCTest

/// Collects the result of every XCTest test in the bundle and, when the bundle finishes,
/// writes a JUnit XML file and a Markdown summary.
///
/// Install it once, for example in the `setUp()` class method of a shared base class:
///
/// ```swift
/// override class func setUp() {
///     super.setUp()
///     TestResultCollector.install()
/// }
/// ```
///
/// Reports go to the folder in the `TESTING_AUTOMATION_REPORT_DIR` environment variable. In
/// `xcodebuild test`, prefix it with `TEST_RUNNER_` so it reaches the test process:
/// `TEST_RUNNER_TESTING_AUTOMATION_REPORT_DIR=$PWD/reports xcodebuild test …`. Without the
/// variable the results are only collected, and ``results`` can be read in a test.
///
/// The files are rewritten after every test. When Xcode runs UI tests in parallel, or starts a
/// new runner process after a crash, each process has its own collector. Pass
/// `perProcessFileNames: true` so each writes `junit-<process id>.xml` and
/// `summary-<process id>.md` instead of replacing the others' files.
///
/// Registered secrets (``TestingAutomation/registerSecret(_:)``) are masked in both files.
public final class TestResultCollector: NSObject, XCTestObservation, @unchecked Sendable {
    /// The environment variable that names the report folder.
    public static let reportDirectoryKey = "TESTING_AUTOMATION_REPORT_DIR"

    // `collected` and `failures` are only touched while holding `lock`.
    private let lock = NSLock()
    private var collected: [TestResult] = []
    private var failures: [String: [String]] = [:]
    /// Where the reports are written when the bundle finishes, if anywhere.
    public let reportDirectory: URL?
    private let reportName: String
    private let fileSuffix: String

    private static let installLock = NSLock()
    // Only read and written while holding `installLock`.
    nonisolated(unsafe) private static var installed: TestResultCollector?

    private init(reportDirectory: URL?, reportName: String, fileSuffix: String) {
        self.reportDirectory = reportDirectory
        self.reportName = reportName
        self.fileSuffix = fileSuffix
    }

    /// Registers the collector with XCTest. Calling it again returns the same collector.
    @discardableResult
    public static func install(
        reportName: String = "UI Tests",
        perProcessFileNames: Bool = false,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) -> TestResultCollector {
        installLock.withLock {
            if let installed { return installed }
            let directory = environment[reportDirectoryKey].flatMap { $0.isEmpty ? nil : URL(fileURLWithPath: $0, isDirectory: true) }
            let suffix = perProcessFileNames ? "-\(ProcessInfo.processInfo.processIdentifier)" : ""
            let collector = TestResultCollector(reportDirectory: directory, reportName: reportName, fileSuffix: suffix)
            XCTestObservationCenter.shared.addTestObserver(collector)
            installed = collector
            return collector
        }
    }

    /// The results collected so far.
    public var results: [TestResult] { lock.withLock { collected } }

    /// A report of the results collected so far.
    public func report() -> TestReport {
        TestReport(name: reportName, results: results, redactor: TestingAutomation.redactor, timestamp: Date())
    }

    // MARK: - XCTestObservation

    public func testCase(_ testCase: XCTestCase, didRecord issue: XCTIssue) {
        let key = testCase.name
        var message = issue.compactDescription
        if let location = issue.sourceCodeContext.location {
            message += " (\(location.fileURL.lastPathComponent):\(location.lineNumber))"
        }
        lock.withLock { failures[key, default: []].append(message) }
    }

    public func testCaseDidFinish(_ testCase: XCTestCase) {
        guard let run = testCase.testRun else { return }
        let (suite, name) = Self.split(testCase.name)
        let status: TestStatus
        if run.hasBeenSkipped {
            status = .skipped
        } else if run.hasSucceeded {
            status = .passed
        } else {
            status = .failed
        }
        lock.withLock {
            let messages = failures.removeValue(forKey: testCase.name) ?? []
            collected.append(TestResult(
                name: name,
                suite: suite,
                status: status,
                duration: run.totalDuration,
                errorMessage: messages.isEmpty ? nil : messages.joined(separator: "\n")
            ))
        }
        // Rewrite the reports after every test, so they are current even if the runner
        // process is ended before the bundle finishes.
        writeReportsIfConfigured()
    }

    public func testBundleDidFinish(_ testBundle: Bundle) {
        writeReportsIfConfigured()
    }

    private func writeReportsIfConfigured() {
        guard let reportDirectory else { return }
        do {
            try writeReports(to: reportDirectory)
        } catch {
            print("TestResultCollector could not write reports to \(reportDirectory.path): \(error)")
        }
    }

    /// Writes `junit.xml` and `summary.md` (with the ``HealingLog`` suggestions) to `directory`.
    /// The file names get a process suffix when the collector was installed with
    /// `perProcessFileNames: true`.
    public func writeReports(to directory: URL) throws {
        let report = report()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try report.junitXML().write(to: directory.appendingPathComponent("junit\(fileSuffix).xml"), atomically: true, encoding: .utf8)
        var summary = report.markdownSummary()
        let healing = HealingLog.report()
        if !healing.isEmpty { summary += "\n" + healing }
        try summary.write(to: directory.appendingPathComponent("summary\(fileSuffix).md"), atomically: true, encoding: .utf8)
    }

    /// Splits `-[Module.Suite testName]` into the suite and the test name.
    static func split(_ name: String) -> (suite: String, name: String) {
        var trimmed = name
        if trimmed.hasPrefix("-[") && trimmed.hasSuffix("]") {
            trimmed = String(trimmed.dropFirst(2).dropLast())
        }
        let parts = trimmed.split(separator: " ", maxSplits: 1).map(String.init)
        guard parts.count == 2 else { return ("", trimmed) }
        let suite = parts[0].split(separator: ".").last.map(String.init) ?? parts[0]
        return (suite, parts[1])
    }
}
#endif
