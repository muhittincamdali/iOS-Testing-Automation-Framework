import Foundation

/// A set of test results that can be written as JUnit XML for CI servers or as a Markdown
/// summary for a pull request or a GitHub Actions job summary.
///
/// Every message passes through ``redactor`` before it is written, so a password typed by a
/// UI test does not end up in a CI artifact.
///
/// ```swift
/// let report = TestReport(name: "Checkout", results: results)
/// try report.junitXML().write(to: reportURL, atomically: true, encoding: .utf8)
/// print(report.markdownSummary())
/// ```
public struct TestReport: Sendable {
    /// The name of the whole run, used for the `<testsuites>` element and the summary title.
    public var name: String
    public var results: [TestResult]
    /// Masks secrets in names and messages. Pass `Redactor(masksCommonPatterns: false)` to keep
    /// messages unchanged apart from registered secrets.
    public var redactor: Redactor
    /// Written as the `timestamp` attribute of each suite when set.
    public var timestamp: Date?

    public init(name: String = "Tests", results: [TestResult], redactor: Redactor = Redactor(), timestamp: Date? = nil) {
        self.name = name
        self.results = results
        self.redactor = redactor
        self.timestamp = timestamp
    }

    // MARK: - Counts

    public var passedCount: Int { results.count { $0.status == .passed } }
    public var failedCount: Int { results.count { $0.status == .failed } }
    public var skippedCount: Int { results.count { $0.status == .skipped } }
    /// The sum of all durations, in seconds.
    public var totalDuration: TimeInterval { results.reduce(0) { $0 + $1.duration } }
    /// True when no test failed. A run with only skipped tests counts as passing.
    public var isPassing: Bool { failedCount == 0 }

    /// The results grouped by suite, in the order each suite first appears.
    public var suites: [(name: String, results: [TestResult])] {
        var order: [String] = []
        var groups: [String: [TestResult]] = [:]
        for result in results {
            let suite = result.suite.isEmpty ? name : result.suite
            if groups[suite] == nil { order.append(suite) }
            groups[suite, default: []].append(result)
        }
        return order.map { ($0, groups[$0] ?? []) }
    }

    // MARK: - JUnit XML

    /// The report in the JUnit XML format read by Jenkins, GitLab, Buildkite, Azure Pipelines
    /// and most test-report actions.
    ///
    /// Text is escaped for XML, and characters that XML 1.0 does not allow (most control
    /// characters) are dropped, so the file always parses.
    public func junitXML() -> String {
        var xml = #"<?xml version="1.0" encoding="UTF-8"?>"# + "\n"
        xml += "<testsuites name=\"\(attribute(name))\" tests=\"\(results.count)\" failures=\"\(failedCount)\" "
        xml += "skipped=\"\(skippedCount)\" time=\"\(Self.seconds(totalDuration))\">\n"
        for suite in suites {
            xml += suiteXML(name: suite.name, results: suite.results)
        }
        xml += "</testsuites>\n"
        return xml
    }

    private func suiteXML(name suiteName: String, results suiteResults: [TestResult]) -> String {
        let failures = suiteResults.count { $0.status == .failed }
        let skipped = suiteResults.count { $0.status == .skipped }
        let time = suiteResults.reduce(0) { $0 + $1.duration }
        var xml = "  <testsuite name=\"\(attribute(suiteName))\" tests=\"\(suiteResults.count)\" "
        xml += "failures=\"\(failures)\" errors=\"0\" skipped=\"\(skipped)\" time=\"\(Self.seconds(time))\""
        if let timestamp {
            xml += " timestamp=\"\(Self.isoTimestamp(timestamp))\""
        }
        xml += ">\n"
        for result in suiteResults {
            xml += caseXML(result, suite: suiteName)
        }
        xml += "  </testsuite>\n"
        return xml
    }

    private func caseXML(_ result: TestResult, suite: String) -> String {
        var xml = "    <testcase name=\"\(attribute(result.name))\" classname=\"\(attribute(suite))\" "
        xml += "time=\"\(Self.seconds(result.duration))\""
        let message = result.errorMessage.map { redactor.redact($0) }
        let hasBody = result.status != .passed || result.attempts > 1
        guard hasBody else { return xml + "/>\n" }
        xml += ">\n"
        if result.attempts > 1 {
            xml += "      <properties><property name=\"attempts\" value=\"\(result.attempts)\"/></properties>\n"
        }
        switch result.status {
        case .failed:
            let text = message ?? "Failed"
            xml += "      <failure message=\"\(Self.escape(Self.summaryLine(text), inAttribute: true))\">"
            xml += Self.escape(text, inAttribute: false) + "</failure>\n"
        case .skipped:
            if let message {
                xml += "      <skipped message=\"\(Self.escape(Self.summaryLine(message), inAttribute: true))\"/>\n"
            } else {
                xml += "      <skipped/>\n"
            }
        case .passed:
            break
        }
        return xml + "    </testcase>\n"
    }

    private func attribute(_ text: String) -> String {
        Self.escape(redactor.redact(text), inAttribute: true)
    }

    // MARK: - Markdown

    /// A short Markdown summary: one line of totals and a table of failed tests.
    ///
    /// Write it to the file named by `GITHUB_STEP_SUMMARY` to show it on the Actions run page.
    /// Messages are cut to their first line and 200 characters; `|` and backticks are escaped so
    /// a message cannot break the table.
    public func markdownSummary() -> String {
        let icon = isPassing ? "Passed" : "Failed"
        var text = "### \(Self.markdownCell(redactor.redact(name))): \(icon)\n\n"
        text += "\(results.count) tests: \(passedCount) passed, \(failedCount) failed, "
        text += "\(skippedCount) skipped in \(Self.seconds(totalDuration)) s.\n"
        let failed = results.filter { $0.status == .failed }
        guard !failed.isEmpty else { return text }
        text += "\n| Test | Message |\n| --- | --- |\n"
        for result in failed {
            let fullName = result.suite.isEmpty ? result.name : "\(result.suite).\(result.name)"
            let message = Self.summaryLine(redactor.redact(result.errorMessage ?? "Failed"))
            text += "| \(Self.markdownCell(redactor.redact(fullName))) | \(Self.markdownCell(message)) |\n"
        }
        return text
    }

    // MARK: - Formatting

    static func seconds(_ value: TimeInterval) -> String {
        guard value.isFinite, value >= 0 else { return "0.000" }
        // String(format:) is not localized, so the decimal separator is always a period.
        return String(format: "%.3f", value)
    }

    private static func isoTimestamp(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    /// The first non-empty line, at most 200 characters.
    static func summaryLine(_ text: String) -> String {
        let line = text.split(whereSeparator: \.isNewline).first.map(String.init) ?? ""
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        guard trimmed.count > 200 else { return trimmed }
        return String(trimmed.prefix(199)) + "…"
    }

    static func escape(_ text: String, inAttribute: Bool) -> String {
        var escaped = ""
        escaped.reserveCapacity(text.utf8.count)
        for scalar in text.unicodeScalars {
            switch scalar {
            case "&": escaped += "&amp;"
            case "<": escaped += "&lt;"
            case ">": escaped += "&gt;"
            case "\"": escaped += "&quot;"
            case "'": escaped += "&apos;"
            case "\n" where inAttribute: escaped += "&#10;"
            case "\r" where inAttribute: escaped += "&#13;"
            case "\t" where inAttribute: escaped += "&#9;"
            default:
                if isAllowedInXML(scalar) { escaped.unicodeScalars.append(scalar) }
            }
        }
        return escaped
    }

    /// XML 1.0 `Char` production: tab, newline, carriage return and everything from U+0020
    /// except surrogates (which `Unicode.Scalar` cannot hold) and U+FFFE, U+FFFF.
    private static func isAllowedInXML(_ scalar: Unicode.Scalar) -> Bool {
        switch scalar.value {
        case 0x9, 0xA, 0xD: return true
        case 0x20...0xFFFD: return true
        case 0x10000...0x10FFFF: return true
        default: return false
        }
    }

    static func markdownCell(_ text: String) -> String {
        var cell = ""
        for character in text {
            switch character {
            case "|": cell += "\\|"
            case "`": cell += "\\`"
            case "<": cell += "&lt;"
            case ">": cell += "&gt;"
            case "\n", "\r", "\r\n": cell += " "
            default: cell.append(character)
            }
        }
        return cell
    }
}
