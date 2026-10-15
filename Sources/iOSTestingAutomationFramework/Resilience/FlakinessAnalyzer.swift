import Foundation

/// Finds flaky tests in the results of several CI runs.
///
/// Feed it the results of the last runs, oldest first (for example, decoded from the JSON each
/// run stored as an artifact). A test is:
///
/// - **flaky** when it both passed and failed in the window, or passed only after a retry
///   (``TestResult/attempts`` above 1);
/// - **failing** when it failed every time it ran;
/// - **stable** otherwise.
///
/// Skipped runs are counted but do not make a test flaky or failing.
///
/// ```swift
/// let report = FlakinessAnalyzer().analyze(history)
/// for entry in report where entry.classification == .flaky {
///     print(entry.name, entry.passRate)
/// }
/// ```
public struct FlakinessAnalyzer: Sendable {
    /// How a test behaved over the analyzed runs.
    public enum Classification: String, Sendable, Codable, Comparable {
        case flaky
        case failing
        case stable

        private var rank: Int {
            switch self {
            case .flaky: 0
            case .failing: 1
            case .stable: 2
            }
        }

        public static func < (lhs: Self, rhs: Self) -> Bool { lhs.rank < rhs.rank }
    }

    /// The history of one test.
    public struct Entry: Sendable, Hashable, Codable {
        public let suite: String
        public let name: String
        public let runs: Int
        public let passes: Int
        public let failures: Int
        public let skips: Int
        /// Passes that needed more than one attempt.
        public let passesAfterRetry: Int
        /// How often the outcome changed between consecutive non-skipped runs.
        public let flips: Int
        public let classification: Classification

        /// Passes divided by the runs that were not skipped, or `nil` if every run was skipped.
        public var passRate: Double? {
            let executed = passes + failures
            return executed == 0 ? nil : Double(passes) / Double(executed)
        }
    }

    public init() {}

    /// Groups `results` by suite and name and classifies each test.
    ///
    /// Entries are ordered flaky first (most flips first), then failing, then stable, and by
    /// name within each group, so the order does not depend on the input order of tests.
    public func analyze(_ results: [TestResult]) -> [Entry] {
        var order: [Key] = []
        var history: [Key: [TestResult]] = [:]
        for result in results {
            let key = Key(suite: result.suite, name: result.name)
            if history[key] == nil { order.append(key) }
            history[key, default: []].append(result)
        }
        return order
            .map { entry(for: $0, runs: history[$0] ?? []) }
            .sorted { lhs, rhs in
                if lhs.classification != rhs.classification { return lhs.classification < rhs.classification }
                if lhs.flips != rhs.flips { return lhs.flips > rhs.flips }
                return (lhs.suite, lhs.name) < (rhs.suite, rhs.name)
            }
    }

    private struct Key: Hashable {
        let suite: String
        let name: String
    }

    private func entry(for key: Key, runs: [TestResult]) -> Entry {
        let passes = runs.count { $0.status == .passed }
        let failures = runs.count { $0.status == .failed }
        let skips = runs.count { $0.status == .skipped }
        let passesAfterRetry = runs.count { $0.status == .passed && $0.attempts > 1 }

        let executed = runs.filter { $0.status != .skipped }.map(\.status)
        let flips = zip(executed, executed.dropFirst()).count { $0 != $1 }

        let classification: Classification
        if (passes > 0 && failures > 0) || passesAfterRetry > 0 {
            classification = .flaky
        } else if failures > 0 {
            classification = .failing
        } else {
            classification = .stable
        }
        return Entry(
            suite: key.suite,
            name: key.name,
            runs: runs.count,
            passes: passes,
            failures: failures,
            skips: skips,
            passesAfterRetry: passesAfterRetry,
            flips: flips,
            classification: classification
        )
    }
}
