import Foundation
import Testing
@testable import iOSTestingAutomationFramework

@Suite("Redactor")
struct RedactorTests {
    @Test("masks registered secrets")
    func masksSecrets() {
        let redactor = Redactor(secrets: ["hunter2"], masksCommonPatterns: false)
        #expect(redactor.redact("login failed with hunter2 twice: hunter2") == "login failed with •••• twice: ••••")
    }

    @Test("ignores empty and whitespace-only secrets")
    func ignoresBlankSecrets() {
        let redactor = Redactor(secrets: ["", "   ", "\n"], masksCommonPatterns: false)
        #expect(redactor.secrets.isEmpty)
        #expect(redactor.redact("a b c") == "a b c")
    }

    @Test("masks overlapping secrets completely")
    func overlappingSecrets() {
        let redactor = Redactor(secrets: ["abcd", "cdef"], mask: "*", masksCommonPatterns: false)
        // Replacing one secret after the other would leave "ef" or "ab" visible.
        #expect(redactor.redact("xxabcdefyy") == "xx*yy")
        #expect(redactor.redact("aaaa") == "aaaa")
    }

    @Test("finds overlapping copies of the same secret")
    func repeatedSecret() {
        let redactor = Redactor(secrets: ["aba"], mask: "#", masksCommonPatterns: false)
        #expect(redactor.redact("ababa") == "#")
    }

    @Test("masks secrets that contain the mask text")
    func secretContainsMask() {
        let redactor = Redactor(secrets: ["x••••y"], masksCommonPatterns: false)
        #expect(redactor.redact("pw x••••y end") == "pw •••• end")
    }

    @Test("masks percent-encoded and JSON-escaped forms")
    func encodedForms() {
        let redactor = Redactor(secrets: ["p@ss/w\"rd"], mask: "#", masksCommonPatterns: false)
        #expect(redactor.redact("GET /login?pw=p%40ss%2Fw%22rd") == "GET /login?pw=#")
        #expect(redactor.redact(##"{"pw":"p@ss\/w\"rd"}"##) == ###"{"pw":"#"}"###)
    }

    @Test("masks a secret wherever a URL encoder put it", arguments: ["p@ss-wörd_1.x", "pässword", "a b+c&d=e/f?g#h"])
    func urlEncoders(secret: String) throws {
        let redactor = Redactor(secrets: [secret], mask: "#", masksCommonPatterns: false)
        var components = try #require(URLComponents(string: "https://example.com/sign-in"))
        components.queryItems = [URLQueryItem(name: "pw", value: secret)]
        let query = try #require(components.percentEncodedQuery)
        #expect(!redactor.redact(query).contains(try #require(query.split(separator: "=").last)))
        #expect(redactor.redact(query) == "pw=#")

        var pathComponents = URLComponents()
        pathComponents.path = "/" + secret
        #expect(redactor.redact(pathComponents.percentEncodedPath) == "/#")

        for allowed in [CharacterSet.urlQueryAllowed, .urlPathAllowed, .urlUserAllowed, .urlPasswordAllowed, .urlFragmentAllowed, .alphanumerics] {
            let encoded = try #require(secret.addingPercentEncoding(withAllowedCharacters: allowed))
            #expect(redactor.redact("x \(encoded) y") == "x # y")
            #expect(redactor.redact("x \(lowercasedHex(encoded)) y") == "x # y")
        }
    }

    @Test("masks form encoding, where a space is a plus")
    func formEncoding() {
        let redactor = Redactor(secrets: ["correct horse+battery"], mask: "#", masksCommonPatterns: false)
        #expect(redactor.redact("user=ada&pw=correct+horse%2Bbattery") == "user=ada&pw=#")
        #expect(redactor.redact("pw=correct%20horse%2bbattery") == "pw=#")
    }

    @Test("masks ASCII-only JSON escapes and decomposed percent-encoding")
    func unicodeEscapes() throws {
        let redactor = Redactor(secrets: ["pässword"], mask: "#", masksCommonPatterns: false)
        #expect(redactor.redact(##"{"pw":"p\u00e4ssword"}"##) == ##"{"pw":"#"}"##)
        #expect(redactor.redact(##"{"pw":"p\u00E4ssword"}"##) == ##"{"pw":"#"}"##)
        let decomposed = try #require("pa\u{308}ssword".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        #expect(decomposed == "pa%CC%88ssword")
        #expect(redactor.redact("pw=\(decomposed)") == "pw=#")
        let json = try String(decoding: JSONEncoder().encode(["pw": "pässword/1"]), as: UTF8.self)
        #expect(Redactor(secrets: ["pässword/1"], mask: "#", masksCommonPatterns: false).redact(json) == ##"{"pw":"#"}"##)
    }

    @Test("matches composed and decomposed Unicode")
    func unicodeEquivalence() {
        let composed = "caf\u{E9}-secret"
        let decomposed = "cafe\u{301}-secret"
        let redactor = Redactor(secrets: [composed], mask: "#", masksCommonPatterns: false)
        #expect(redactor.redact("token \(decomposed) end") == "token # end")
    }

    @Test("masks values after credential keys and bearer tokens")
    func patterns() {
        let redactor = Redactor(mask: "#")
        #expect(redactor.redact("password=hunter2&user=ada") == "password=#&user=ada")
        #expect(redactor.redact(##"{"api_key": "abc123", "id": 4}"##) == ##"{"api_key": "#", "id": 4}"##)
        #expect(redactor.redact("Authorization: Bearer eyJhbGciOi.payload.sig") == "Authorization: Bearer #")
        #expect(redactor.redact("TOKEN: xyz") == "TOKEN: #")
        #expect(redactor.redact("no secrets here") == "no secrets here")
    }

    @Test("leaves patterns alone when turned off")
    func patternsOff() {
        let redactor = Redactor(masksCommonPatterns: false)
        #expect(redactor.redact("password=hunter2") == "password=hunter2")
    }
}

@Suite("TestReport")
struct TestReportTests {
    let results = [
        TestResult(name: "testSignIn", suite: "SignInTests", status: .passed, duration: 1.25),
        TestResult(name: "testWrongPassword", suite: "SignInTests", status: .failed, duration: 0.5,
                   errorMessage: "Expected \"Welcome\" <b> & 'x'\nsecond line"),
        TestResult(name: "testOffline", suite: "CatalogTests", status: .skipped, duration: 0, errorMessage: "Needs a server"),
        TestResult(name: "testRetry", suite: "CatalogTests", status: .passed, duration: 2, attempts: 3)
    ]

    @Test("counts the results")
    func counts() {
        let report = TestReport(results: results)
        #expect(report.passedCount == 2)
        #expect(report.failedCount == 1)
        #expect(report.skippedCount == 1)
        #expect(report.totalDuration == 3.75)
        #expect(!report.isPassing)
        #expect(report.suites.map(\.name) == ["SignInTests", "CatalogTests"])
    }

    @Test("writes JUnit XML that parses and keeps the structure")
    func junitParses() throws {
        let root = try XMLNode.parse(TestReport(name: "UI", results: results).junitXML())
        #expect(root.name == "testsuites")
        #expect(root.attributes["tests"] == "4")
        #expect(root.attributes["failures"] == "1")
        #expect(root.attributes["time"] == "3.750")
        #expect(root.children.filter { $0.name == "testsuite" }.count == 2)
        let failure = try #require(root.testcase(named: "testWrongPassword")?.child("failure"))
        #expect(failure.attributes["message"] == "Expected \"Welcome\" <b> & 'x'")
        #expect(failure.text == "Expected \"Welcome\" <b> & 'x'\nsecond line")
        #expect(root.testcase(named: "testOffline")?.child("skipped") != nil)
        let property = root.testcase(named: "testRetry")?.child("properties")?.child("property")
        #expect(property?.attributes["name"] == "attempts")
        #expect(property?.attributes["value"] == "3")
    }

    @Test("drops characters XML cannot hold so the file still parses")
    func controlCharacters() throws {
        let nasty = TestResult(name: "test\u{0}\u{1B}[31mred\u{FFFE}", suite: "S\u{7}", status: .failed, duration: 1,
                               errorMessage: "bad \u{8} byte ]]> <![CDATA[")
        let root = try XMLNode.parse(TestReport(results: [nasty]).junitXML())
        let testcase = try #require(root.testcase(named: "test[31mred"))
        #expect(testcase.child("failure")?.text == "bad  byte ]]> <![CDATA[")
    }

    @Test("writes durations with a period, never NaN or negative")
    func durationFormatting() {
        #expect(TestReport.seconds(1.5) == "1.500")
        #expect(TestReport.seconds(.nan) == "0.000")
        #expect(TestReport.seconds(-3) == "0.000")
        #expect(TestReport.seconds(.infinity) == "0.000")
        let huge = [TestResult(name: "a", suite: "", status: .passed, duration: .greatestFiniteMagnitude),
                    TestResult(name: "b", suite: "", status: .passed, duration: .greatestFiniteMagnitude)]
        #expect(TestReport(results: huge).junitXML().contains("time=\"0.000\""))
    }

    @Test("masks secrets in names and messages")
    func redaction() {
        let leaking = TestResult(name: "testLogin_hunter2", suite: "Auth", status: .failed, duration: 1,
                                 errorMessage: "typed hunter2 then password=letmein")
        let report = TestReport(results: [leaking], redactor: Redactor(secrets: ["hunter2"]))
        let xml = report.junitXML()
        let markdown = report.markdownSummary()
        for output in [xml, markdown] {
            #expect(!output.contains("hunter2"))
            #expect(!output.contains("letmein"))
        }
    }

    @Test("Markdown summary escapes table characters and lists only failures")
    func markdown() {
        let failing = TestResult(name: "testPipe", suite: "S", status: .failed, duration: 1, errorMessage: "a | b `code`\nmore")
        let summary = TestReport(name: "Run", results: [failing, results[0]]).markdownSummary()
        #expect(summary.contains("### Run: Failed"))
        #expect(summary.contains("2 tests: 1 passed, 1 failed, 0 skipped"))
        #expect(summary.contains("| S.testPipe | a \\| b \\`code\\` |"))
        #expect(!summary.contains("testSignIn"))
        #expect(TestReport(results: [results[0]]).markdownSummary().contains("Passed"))
    }

    @Test("summary lines are cut to 200 characters")
    func summaryLine() {
        let long = String(repeating: "x", count: 500)
        #expect(TestReport.summaryLine(long).count == 200)
        #expect(TestReport.summaryLine("\n\nfirst\nsecond") == "first")
    }
}

@Suite("TestResult")
struct TestResultTests {
    @Test("stores invalid durations as zero and at least one attempt")
    func sanitizes() {
        #expect(TestResult(name: "a", status: .passed, duration: .nan).duration == 0)
        #expect(TestResult(name: "a", status: .passed, duration: -1).duration == 0)
        #expect(TestResult(name: "a", status: .passed, duration: .infinity).duration == 0)
        #expect(TestResult(name: "a", suite: "", status: .passed, duration: 1, attempts: -5).attempts == 1)
    }

    @Test("decodes results written by version 1 and applies the same limits")
    func decodesOldFormat() throws {
        let json = #"[{"id":"6F1C9B5E-7B7D-4E0E-9B6B-3B1B4E8A9C11","name":"testA","status":"failed","duration":-2,"errorMessage":"x"}]"#
        let decoded = try JSONDecoder().decode([TestResult].self, from: Data(json.utf8))
        #expect(decoded.first?.suite == "")
        #expect(decoded.first?.duration == 0)
        #expect(decoded.first?.attempts == 1)
        #expect(decoded.first?.status == .failed)
    }

    @Test("round-trips through JSON")
    func roundTrip() throws {
        let result = TestResult(name: "t", suite: "S", status: .skipped, duration: 0.25, errorMessage: "m", attempts: 2)
        let decoded = try JSONDecoder().decode(TestResult.self, from: JSONEncoder().encode(result))
        #expect(decoded == result)
    }
}

@Suite("Secrets and version", .serialized)
struct SecretRegistryTests {
    @Test("registered secrets are masked by the shared redactor")
    func secretRegistry() {
        defer { TestingAutomation.removeAllSecrets() }
        TestingAutomation.registerSecret("pa55word")
        #expect(TestingAutomation.redactor.redact("typed pa55word") == "typed ••••")
        TestingAutomation.removeAllSecrets()
        #expect(TestingAutomation.redactor.redact("typed pa55word") == "typed pa55word")
    }

    @Test("the package version")
    func version() {
        #expect(TestingAutomation.version.split(separator: ".").count == 3)
    }
}

/// A minimal XML tree built with `XMLParser`, which exists on every Apple platform.
final class XMLNode {
    let name: String
    let attributes: [String: String]
    var children: [XMLNode] = []
    var text = ""

    init(name: String, attributes: [String: String]) {
        self.name = name
        self.attributes = attributes
    }

    func child(_ name: String) -> XMLNode? { children.first { $0.name == name } }

    func testcase(named name: String) -> XMLNode? {
        if self.name == "testcase", attributes["name"] == name { return self }
        for child in children {
            if let found = child.testcase(named: name) { return found }
        }
        return nil
    }

    struct ParseError: Error { let underlying: (any Error)? }

    static func parse(_ xml: String) throws -> XMLNode {
        let builder = Builder()
        let parser = XMLParser(data: Data(xml.utf8))
        parser.delegate = builder
        guard parser.parse(), let root = builder.root else { throw ParseError(underlying: parser.parserError) }
        return root
    }

    private final class Builder: NSObject, XMLParserDelegate {
        var root: XMLNode?
        var stack: [XMLNode] = []

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                    qualifiedName: String?, attributes: [String: String]) {
            let node = XMLNode(name: elementName, attributes: attributes)
            stack.last?.children.append(node)
            if root == nil { root = node }
            stack.append(node)
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName: String?) {
            stack.removeLast()
        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {
            stack.last?.text += string
        }
    }
}

/// `%C3%B6` → `%c3%b6`, as some encoders write percent-escapes.
private func lowercasedHex(_ encoded: String) -> String {
    var result = ""
    var remaining = 0
    for character in encoded {
        if character == "%" {
            remaining = 2
            result.append(character)
        } else if remaining > 0 {
            remaining -= 1
            result += character.lowercased()
        } else {
            result.append(character)
        }
    }
    return result
}
