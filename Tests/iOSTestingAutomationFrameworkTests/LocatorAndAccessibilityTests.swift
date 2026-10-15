import CoreGraphics
import Testing
@testable import iOSTestingAutomationFramework

@Suite("LocatorHealer")
struct LocatorHealerTests {
    let screen = [
        ElementDescriptor(kind: .window),
        ElementDescriptor(kind: .staticText, label: "Sign In"),
        ElementDescriptor(kind: .textField, identifier: "signIn.email", placeholder: "Email"),
        ElementDescriptor(kind: .secureTextField, placeholder: "Password"),
        ElementDescriptor(kind: .button, identifier: "signIn.submit", label: "Sign In"),
        ElementDescriptor(kind: .button, identifier: "signIn.forgot", label: "Forgot password?")
    ]
    let healer = LocatorHealer()

    @Test("finds the element by its identifier first")
    func exactIdentifier() throws {
        let match = try #require(healer.resolve(Locator("signIn.submit"), in: screen).match)
        #expect(match.index == 4)
        #expect(match.strategy == .identifier)
        #expect(!match.isHealed)
    }

    @Test("heals by label, preferring the one interactive element that shows it")
    func healsByLabel() throws {
        let match = try #require(healer.resolve(Locator("loginButton", label: "sign in "), in: screen).match)
        #expect(match.index == 4)
        #expect(match.strategy == .label)
        #expect(match.isHealed)
    }

    @Test("heals by placeholder")
    func healsByPlaceholder() throws {
        let match = try #require(healer.resolve(Locator("password", placeholder: "password", kind: .secureTextField), in: screen).match)
        #expect(match.index == 3)
        #expect(match.strategy == .placeholder)
    }

    @Test("heals a renamed identifier that only gained a prefix or changed its style")
    func healsSimilarIdentifier() throws {
        let renamed = [ElementDescriptor(kind: .button, identifier: "auth.login_button"),
                       ElementDescriptor(kind: .button, identifier: "auth.register")]
        let match = try #require(healer.resolve(Locator("loginButton"), in: renamed).match)
        #expect(match.index == 0)
        #expect(match.strategy == .similarIdentifier)
        #expect(match.score >= 0.8)
    }

    @Test("does not heal to an identifier that is only somewhat alike")
    func rejectsDistantIdentifiers() {
        let elements = [ElementDescriptor(kind: .button, identifier: "signupButton")]
        #expect(healer.resolve(Locator("loginButton"), in: elements) == .notFound)
    }

    @Test("reports ambiguity instead of guessing")
    func ambiguity() {
        let elements = [ElementDescriptor(kind: .button, label: "Delete"), ElementDescriptor(kind: .button, label: "Delete")]
        guard case .ambiguous(let candidates, let strategy) = healer.resolve(Locator("delete", label: "Delete"), in: elements) else {
            Issue.record("Expected an ambiguous result")
            return
        }
        #expect(candidates.count == 2)
        #expect(strategy == .label)

        let twins = [ElementDescriptor(kind: .cell, identifier: "rowItem-1"), ElementDescriptor(kind: .cell, identifier: "rowItem_2")]
        if case .ambiguous = healer.resolve(Locator("rowItem"), in: twins) {} else {
            Issue.record("Expected equally similar identifiers to be ambiguous")
        }
    }

    @Test("treats a container and its child with the same identifier as one target")
    func sameIdentifierIsNotAmbiguous() throws {
        let elements = [ElementDescriptor(kind: .button, identifier: "card.buy"), ElementDescriptor(kind: .button, identifier: "card.buy")]
        let match = try #require(healer.resolve(Locator("cardBuy"), in: elements).match)
        #expect(match.index == 0)
    }

    @Test("respects the element kind")
    func kindFilter() {
        #expect(healer.resolve(Locator("signIn.submit", kind: .link), in: screen) == .notFound)
    }

    @Test("skips similarity work on very long identifiers and empty input")
    func boundedInput() {
        let long = String(repeating: "a", count: 10_000)
        let elements = [ElementDescriptor(kind: .button, identifier: long + "b")]
        #expect(healer.resolve(Locator(long), in: elements) == .notFound)
        #expect(healer.resolve(Locator(""), in: elements) == .notFound)
        #expect(healer.resolve(Locator("x"), in: []) == .notFound)
    }

    @Test("clamps the similarity threshold")
    func threshold() {
        #expect(LocatorHealer(minimumSimilarity: .nan).minimumSimilarity == 0.8)
        #expect(LocatorHealer(minimumSimilarity: 0).minimumSimilarity == 0.5)
        #expect(LocatorHealer(minimumSimilarity: 7).minimumSimilarity == 1)
    }

    @Test("edit distance")
    func editDistance() {
        func distance(_ lhs: String, _ rhs: String) -> Int {
            LocatorHealer.editDistance(Array(lhs.unicodeScalars), Array(rhs.unicodeScalars))
        }
        #expect(distance("kitten", "sitting") == 3)
        #expect(distance("", "abc") == 3)
        #expect(distance("abc", "abc") == 0)
        #expect(LocatorHealer.normalized("Sign_In.Button-2") == Array("signinbutton2".unicodeScalars))
    }
}

@Suite("AccessibilityAudit", .serialized)
struct AccessibilityAuditTests {
    @Test("reports a button without a label and an image without a description")
    func missingLabels() {
        let issues = AccessibilityAudit().run(on: [
            ElementDescriptor(kind: .button, identifier: "close", frame: CGRect(x: 0, y: 0, width: 44, height: 44)),
            ElementDescriptor(kind: .image, frame: CGRect(x: 0, y: 0, width: 80, height: 80)),
            ElementDescriptor(kind: .staticText, frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        ])
        #expect(issues.map(\.rule) == [.missingLabel, .imageWithoutLabel])
        #expect(issues[0].message.contains("close"))
    }

    @Test("accepts a placeholder as the label of a text field")
    func placeholderCounts() {
        let field = ElementDescriptor(kind: .textField, placeholder: "Email", frame: CGRect(x: 0, y: 0, width: 300, height: 44))
        #expect(AccessibilityAudit().run(on: [field]).isEmpty)
    }

    @Test("reports small touch targets, but not disabled or invalid frames")
    func touchTargets() {
        let small = ElementDescriptor(kind: .button, label: "Info", frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let disabled = ElementDescriptor(kind: .button, label: "Info", frame: CGRect(x: 0, y: 0, width: 24, height: 24), isEnabled: false)
        let almost = ElementDescriptor(kind: .button, label: "OK", frame: CGRect(x: 0, y: 0, width: 43.999, height: 44))
        let broken = ElementDescriptor(kind: .button, label: "Odd", frame: CGRect(x: CGFloat.nan, y: 0, width: 10, height: 10))
        let huge = ElementDescriptor(kind: .button, label: "Big", frame: CGRect(x: 0, y: 0, width: 1e300, height: 2))
        let issues = AccessibilityAudit().run(on: [small, disabled, almost, broken, huge])
        #expect(issues.map(\.rule) == [.smallTouchTarget, .smallTouchTarget])
        #expect(issues[0].message.contains("24 × 24 pt"))
        // A frame too large for Int must not stop the process while the message is formatted.
        #expect(issues[1].message.contains("Big"))
    }

    @Test("skips the size rule for controls in navigation bars, tab bars and toolbars")
    func systemBars() {
        let small = CGRect(x: 0, y: 0, width: 90, height: 36)
        let issues = AccessibilityAudit(rules: [.smallTouchTarget]).run(on: [
            ElementDescriptor(kind: .application, depth: 0),
            ElementDescriptor(kind: .navigationBar, depth: 1),
            ElementDescriptor(kind: .other, depth: 2),
            ElementDescriptor(kind: .button, label: "Sign Out", frame: small, depth: 3),
            ElementDescriptor(kind: .toolbar, depth: 1),
            ElementDescriptor(kind: .button, label: "Share", frame: small, depth: 2),
            // Back at depth 1: no longer inside a bar.
            ElementDescriptor(kind: .button, label: "Details", frame: small, depth: 1),
            // A depth that skips levels still finds its bar ancestor.
            ElementDescriptor(kind: .tabBar, depth: 1),
            ElementDescriptor(kind: .button, label: "Home", frame: small, depth: 5)
        ])
        #expect(issues.map(\.element.label) == ["Details"])
    }

    @Test("treats elements inside a control as part of it")
    func partsOfControls() {
        let issues = AccessibilityAudit().run(on: [
            ElementDescriptor(kind: .switch, identifier: "prices", label: "Show prices",
                              frame: CGRect(x: 0, y: 0, width: 360, height: 52), depth: 0),
            ElementDescriptor(kind: .switch, frame: CGRect(x: 280, y: 12, width: 63, height: 28), depth: 1),
            ElementDescriptor(kind: .button, identifier: "row.1", label: "Kettle",
                              frame: CGRect(x: 0, y: 60, width: 360, height: 52), depth: 0),
            ElementDescriptor(kind: .image, identifier: "chevron.forward", frame: CGRect(x: 340, y: 70, width: 10, height: 16), depth: 1),
            ElementDescriptor(kind: .button, identifier: "row.2", label: "Grinder",
                              frame: CGRect(x: 0, y: 120, width: 360, height: 52), depth: 0),
            ElementDescriptor(kind: .image, identifier: "chevron.forward", frame: CGRect(x: 340, y: 130, width: 10, height: 16), depth: 1),
            // A standalone image is still checked.
            ElementDescriptor(kind: .image, frame: CGRect(x: 0, y: 200, width: 80, height: 80), depth: 0)
        ])
        #expect(issues.map(\.rule) == [.imageWithoutLabel])
    }

    @Test("a huge or negative depth neither traps nor allocates without bound")
    func extremeDepths() {
        let issues = AccessibilityAudit(rules: [.missingLabel]).run(on: [
            ElementDescriptor(kind: .other, depth: .max),
            ElementDescriptor(kind: .button, depth: .max),
            ElementDescriptor(kind: .button, depth: .min),
            ElementDescriptor(kind: .button, depth: -1)
        ])
        // The first button sits below a level-capped `.other`, so it is checked on its own.
        #expect(issues.count == 3)
    }

    @Test("a non-finite minimum turns the size rule off")
    func nonFiniteMinimum() {
        let small = ElementDescriptor(kind: .button, label: "Info", frame: CGRect(x: 0, y: 0, width: 4, height: 4))
        let audit = AccessibilityAudit(minimumTouchTarget: CGSize(width: CGFloat.nan, height: -1))
        #expect(audit.run(on: [small]).isEmpty)
    }

    @Test("reports labels that repeat the element kind")
    func repeatedKind() {
        let issues = AccessibilityAudit(rules: [.labelRepeatsKind]).run(on: [
            ElementDescriptor(kind: .button, label: "Close button"),
            ElementDescriptor(kind: .image, label: "Profile picture"),
            ElementDescriptor(kind: .button, label: "Buttonhole settings")
        ])
        #expect(issues.count == 2)
    }

    @Test("reports duplicate identifiers once, ignoring containers that share one with a child")
    func duplicates() {
        let issues = AccessibilityAudit(rules: [.duplicateIdentifier]).run(on: [
            ElementDescriptor(kind: .button, identifier: "buy", label: "Buy"),
            ElementDescriptor(kind: .button, identifier: "buy", label: "Buy"),
            ElementDescriptor(kind: .button, identifier: "buy", label: "Buy"),
            ElementDescriptor(kind: .other, identifier: "card"),
            ElementDescriptor(kind: .staticText, identifier: "card", label: "Card")
        ])
        #expect(issues.count == 1)
        #expect(issues.first?.rule == .duplicateIdentifier)
    }

    @Test("checks only the selected rules")
    func ruleSelection() {
        let unlabeled = ElementDescriptor(kind: .button, frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        #expect(AccessibilityAudit(rules: []).run(on: [unlabeled]).isEmpty)
        #expect(AccessibilityAudit(rules: [.smallTouchTarget]).run(on: [unlabeled]).map(\.rule) == [.smallTouchTarget])
    }
}

@Suite("ContrastRatio")
struct ContrastRatioTests {
    @Test("black on white is 21:1 and a color on itself is 1:1")
    func extremes() throws {
        let max = try #require(ContrastRatio(foreground: "#000", background: "#FFFFFF"))
        #expect(abs(max.value - 21) < 0.001)
        let same = try #require(ContrastRatio(foreground: "0071E3", background: "#0071e3"))
        #expect(same.value == 1)
    }

    @Test("#767676 on white just passes AA for normal text")
    func aaBoundary() throws {
        let ratio = try #require(ContrastRatio(foreground: "#767676", background: "#FFFFFF"))
        #expect(ratio.passesAA())
        #expect(!ratio.passesAAA())
        #expect(ratio.description == "4.54:1")
        let lighter = try #require(ContrastRatio(foreground: "#777777", background: "#FFFFFF"))
        #expect(!lighter.passesAA())
        #expect(lighter.passesAA(largeText: true))
    }

    @Test("rejects malformed hex strings")
    func invalidHex() {
        for bad in ["", "#", "#12", "#12345", "#GGGGGG", "#１２３", "0x123456", "#1234567"] {
            #expect(ContrastRatio.Color(hex: bad) == nil, "\(bad)")
        }
        #expect(ContrastRatio.Color(hex: "#11223344") != nil)
    }

    @Test("clamps components and treats NaN as zero")
    func clamping() {
        let color = ContrastRatio.Color(red: .nan, green: 2, blue: -1)
        #expect(color == ContrastRatio.Color(red: 0, green: 1, blue: 0))
    }
}

@Suite("HealingLog", .serialized)
struct HealingLogTests {
    @Test("the healing log keeps unique events and suggests the fix")
    func healingLog() {
        HealingLog.reset()
        defer { HealingLog.reset() }
        let element = ElementDescriptor(kind: .button, label: "Sign In")
        let event = HealingLog.Event(locator: Locator("loginButton", label: "Sign In"), element: element, strategy: .label, score: 1)
        HealingLog.record(event)
        HealingLog.record(event)
        #expect(HealingLog.events.count == 1)
        #expect(event.suggestion.contains(#".accessibilityIdentifier("loginButton")"#))
        #expect(HealingLog.report().contains("`loginButton` was found by label"))

        let renamed = HealingLog.Event(locator: Locator("loginButton"), element: ElementDescriptor(kind: .button, identifier: "auth.login"),
                                       strategy: .similarIdentifier, score: 0.9)
        #expect(renamed.suggestion.contains("auth.login"))
        for index in 0..<(HealingLog.capacity + 10) {
            HealingLog.record(HealingLog.Event(locator: Locator("id\(index)"), element: element, strategy: .label, score: 1))
        }
        #expect(HealingLog.events.count == HealingLog.capacity)
        HealingLog.reset()
        #expect(HealingLog.report().isEmpty)
    }
}
