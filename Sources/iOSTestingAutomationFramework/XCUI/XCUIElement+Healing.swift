#if canImport(XCTest)
import XCTest

extension XCUIElement {
    /// Finds the descendant `locator` describes, healing the lookup when the identifier no
    /// longer matches.
    ///
    /// The element is first looked up by identifier, waiting up to `timeout`. If it does not
    /// appear, one snapshot of the tree is taken and ``LocatorHealer`` picks an element by
    /// label, placeholder or a similar identifier. A healed lookup is logged as an XCTest
    /// activity and in ``HealingLog`` with the identifier to fix.
    ///
    /// When nothing matches, or several elements match equally well, the original query is
    /// returned, so the next tap or assertion fails with XCTest's usual message.
    ///
    /// ```swift
    /// app.element(Locator("signIn.submit", label: "Sign In", kind: .button)).tap()
    /// ```
    @MainActor
    public func element(_ locator: Locator, timeout: TimeInterval = 2, healer: LocatorHealer = LocatorHealer()) -> XCUIElement {
        let type = locator.kind?.elementType ?? .any
        let timeout = Self.sanitizedTimeout(timeout)
        let primary = descendants(matching: type).matching(identifier: locator.identifier).firstMatch
        if locator.identifier.isEmpty {
            // Nothing to look up directly: wait for any element the fallbacks could match.
            _ = fallbackQuery(for: locator, type: type)?.waitForExistence(timeout: timeout)
        } else if primary.waitForExistence(timeout: timeout) {
            return primary
        }
        guard let elements = try? descriptors() else { return primary }
        switch healer.resolve(locator, in: elements) {
        case .found(let match):
            if match.isHealed {
                HealingLog.record(HealingLog.Event(locator: locator, element: match.element, strategy: match.strategy, score: match.score))
                XCTContext.runActivity(named: "Healed \(locator.identifier) by \(match.strategy.rawValue): \(match.element.summary)") { _ in }
            }
            return query(for: match.element)
        case .ambiguous(let candidates, let strategy):
            let names = candidates.prefix(5).map(\.summary).joined(separator: "; ")
            XCTContext.runActivity(named: "Could not heal \(locator.identifier): \(strategy.rawValue) matches \(candidates.count) elements (\(names))") { _ in }
            return primary
        case .notFound:
            return primary
        }
    }

    /// Elements whose label or placeholder equals one of the locator's, ignoring case.
    @MainActor
    private func fallbackQuery(for locator: Locator, type: XCUIElement.ElementType) -> XCUIElement? {
        var predicates = locator.labels.map { NSPredicate(format: "label ==[c] %@", $0) }
        if let placeholder = locator.placeholder {
            predicates.append(NSPredicate(format: "placeholderValue ==[c] %@", placeholder))
        }
        guard !predicates.isEmpty else { return nil }
        return descendants(matching: type).matching(NSCompoundPredicate(orPredicateWithSubpredicates: predicates)).firstMatch
    }

    /// A query that finds the element a descriptor was made from.
    @MainActor
    func query(for descriptor: ElementDescriptor) -> XCUIElement {
        let candidates = descendants(matching: descriptor.kind.elementType)
        if !descriptor.identifier.isEmpty {
            return candidates.matching(identifier: descriptor.identifier).firstMatch
        }
        if !descriptor.label.isEmpty {
            return candidates.matching(NSPredicate(format: "label == %@", descriptor.label)).firstMatch
        }
        if let placeholder = descriptor.placeholder, !placeholder.isEmpty {
            return candidates.matching(NSPredicate(format: "placeholderValue == %@", placeholder)).firstMatch
        }
        return candidates.firstMatch
    }
}
#endif
