import Foundation

/// A record of every locator that was healed during the test run, with the identifier to set
/// so it no longer needs healing.
///
/// Print ``report()`` at the end of a run (``TestResultCollector`` adds it to the Markdown
/// summary) and fix the identifiers it lists: a healed locator is a test that still passes but
/// is one more UI change away from failing.
public enum HealingLog {
    /// One healed lookup.
    public struct Event: Sendable, Hashable, Codable {
        public let locator: Locator
        /// The element that was used instead.
        public let element: ElementDescriptor
        public let strategy: LocatorHealer.Strategy
        public let score: Double

        /// What to change in the app so the locator matches directly.
        public var suggestion: String {
            if element.identifier.isEmpty {
                return "Add .accessibilityIdentifier(\"\(locator.identifier)\") to \(element.summary)"
            }
            return "Update the locator \"\(locator.identifier)\" to \"\(element.identifier)\", or rename the identifier of \(element.summary)"
        }
    }

    private static let store = EventStore()

    /// The most events the log keeps; later events are dropped.
    public static let capacity = 1_000

    /// Adds an event. The XCUITest layer calls this when it heals a locator.
    public static func record(_ event: Event) {
        store.append(event, capacity: capacity)
    }

    /// Events in the order they happened, without repeats of the same locator and element.
    public static var events: [Event] { store.events }

    /// Forgets all events.
    public static func reset() { store.reset() }

    /// A Markdown list of suggestions, or an empty string when nothing was healed.
    public static func report() -> String {
        let events = self.events
        guard !events.isEmpty else { return "" }
        var text = "### Healed locators\n\n"
        for event in events {
            text += "- `\(event.locator.identifier)` was found by \(event.strategy.rawValue): \(event.suggestion)\n"
        }
        return text
    }
}

private final class EventStore: @unchecked Sendable {
    // `stored` is only read and written while holding `lock`.
    private let lock = NSLock()
    private var stored: [HealingLog.Event] = []

    func append(_ event: HealingLog.Event, capacity: Int) {
        lock.withLock {
            guard stored.count < capacity, !stored.contains(event) else { return }
            stored.append(event)
        }
    }

    var events: [HealingLog.Event] { lock.withLock { stored } }

    func reset() { lock.withLock { stored = [] } }
}
