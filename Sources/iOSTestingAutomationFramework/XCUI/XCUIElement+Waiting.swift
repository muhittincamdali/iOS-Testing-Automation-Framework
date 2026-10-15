#if canImport(XCTest)
import XCTest

extension XCUIElement {
    /// Waits until the element exists and can be tapped, which is later than it existing:
    /// an element can exist while it is still animating in or covered by another view.
    ///
    /// - Returns: Whether the element became hittable in time.
    @MainActor
    @discardableResult
    public func waitForHittable(timeout: TimeInterval = 5) -> Bool {
        wait(for: NSPredicate(format: "exists == true AND hittable == true"), timeout: timeout)
    }

    /// Waits until the element no longer exists, for example after a sheet closes.
    @MainActor
    @discardableResult
    public func waitForDisappearance(timeout: TimeInterval = 5) -> Bool {
        wait(for: NSPredicate(format: "exists == false"), timeout: timeout)
    }

    /// Waits until the element's `label` equals `label`.
    @MainActor
    @discardableResult
    public func waitForLabel(_ label: String, timeout: TimeInterval = 5) -> Bool {
        wait(for: NSPredicate(format: "exists == true AND label == %@", label), timeout: timeout)
    }

    /// Waits until the element's `value`, as text, equals `value`.
    @MainActor
    @discardableResult
    public func waitForValue(_ value: String, timeout: TimeInterval = 5) -> Bool {
        wait(for: NSPredicate(format: "exists == true AND value == %@", value), timeout: timeout)
    }

    @MainActor
    private func wait(for predicate: NSPredicate, timeout: TimeInterval) -> Bool {
        // XCTNSPredicateExpectation first evaluates after about a second, so a condition that
        // already holds would still wait, and a timeout under a second would fail. Check now.
        if predicate.evaluate(with: self) { return true }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: Self.sanitizedTimeout(timeout)) == .completed
    }

    /// Timeouts that are negative or NaN become 0; longer ones are capped at one hour, so a
    /// typo cannot hang a CI job forever.
    static func sanitizedTimeout(_ timeout: TimeInterval) -> TimeInterval {
        guard !timeout.isNaN else { return 0 }
        return min(max(timeout, 0), 3_600)
    }
}
#endif
