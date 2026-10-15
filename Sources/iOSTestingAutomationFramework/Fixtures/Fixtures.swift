import Foundation

/// A random number generator that always produces the same numbers for the same seed
/// (SplitMix64), so randomized test data can be reproduced.
public struct SeededRandomNumberGenerator: RandomNumberGenerator, Sendable {
    private var state: UInt64

    public init(seed: UInt64) {
        state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

/// Generates test data that looks real and is the same on every run with the same seed.
///
/// ```swift
/// var fixtures = Fixtures(seed: 42)
/// let user = User(id: fixtures.uuid(), name: fixtures.fullName(), email: fixtures.email())
/// ```
///
/// Print ``seed`` when a randomized test fails, then pass it back in to reproduce the run.
/// Every email address uses the reserved `example.com` domain, so a test can never send mail
/// to a real person.
public struct Fixtures: Sendable {
    /// The seed this generator started from.
    public let seed: UInt64
    private var generator: SeededRandomNumberGenerator

    /// The longest string ``string(length:from:)`` returns.
    public static let maximumStringLength = 10_000

    public init(seed: UInt64) {
        self.seed = seed
        generator = SeededRandomNumberGenerator(seed: seed)
    }

    /// Uses the seed in the `TESTING_AUTOMATION_SEED` environment variable, or a fresh random
    /// seed when it is missing or not a number.
    public static func fromEnvironment(_ environment: [String: String] = ProcessInfo.processInfo.environment) -> Fixtures {
        let seed = environment["TESTING_AUTOMATION_SEED"].flatMap { UInt64($0) } ?? UInt64.random(in: .min ... .max)
        return Fixtures(seed: seed)
    }

    /// A number in `range`.
    public mutating func int(in range: ClosedRange<Int>) -> Int {
        Int.random(in: range, using: &generator)
    }

    /// A number in `range`. A range with an infinite bound returns its finite bound (or 0).
    public mutating func double(in range: ClosedRange<Double>) -> Double {
        guard range.lowerBound.isFinite, range.upperBound.isFinite else {
            return range.lowerBound.isFinite ? range.lowerBound : (range.upperBound.isFinite ? range.upperBound : 0)
        }
        // Double.random(in:) stops the process when the range is wider than the largest Double
        // (for example -1e308...1e308); halving both bounds keeps the width finite.
        guard (range.upperBound - range.lowerBound).isFinite else {
            return Double.random(in: (range.lowerBound / 2)...(range.upperBound / 2), using: &generator) * 2
        }
        return Double.random(in: range, using: &generator)
    }

    public mutating func bool() -> Bool {
        Bool.random(using: &generator)
    }

    /// An element of `collection`, or `nil` if it is empty.
    public mutating func element<C: Collection>(of collection: C) -> C.Element? {
        collection.randomElement(using: &generator)
    }

    /// The collection's elements in a random order.
    public mutating func shuffled<C: Collection>(_ collection: C) -> [C.Element] {
        collection.shuffled(using: &generator)
    }

    /// A version 4 UUID built from the generator's numbers.
    public mutating func uuid() -> UUID {
        var bytes = [UInt8](repeating: 0, count: 16)
        for index in bytes.indices { bytes[index] = UInt8.random(in: .min ... .max, using: &generator) }
        bytes[6] = (bytes[6] & 0x0F) | 0x40 // version 4
        bytes[8] = (bytes[8] & 0x3F) | 0x80 // RFC 4122 variant
        return UUID(uuid: (bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7],
                           bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]))
    }

    /// A string of `length` characters taken from `alphabet`.
    ///
    /// The length is clamped to 0...``maximumStringLength``; an empty alphabet gives an empty
    /// string.
    public mutating func string(length: Int, from alphabet: String = "abcdefghijklmnopqrstuvwxyz0123456789") -> String {
        let characters = Array(alphabet)
        let length = min(max(length, 0), Self.maximumStringLength)
        guard !characters.isEmpty else { return "" }
        var result = ""
        for _ in 0..<length { result.append(characters[Int.random(in: 0..<characters.count, using: &generator)]) }
        return result
    }

    public mutating func firstName() -> String { element(of: Self.firstNames) ?? "Ada" }
    public mutating func lastName() -> String { element(of: Self.lastNames) ?? "Lovelace" }
    public mutating func fullName() -> String { "\(firstName()) \(lastName())" }

    /// An address such as `amara.okafor42@example.com`.
    public mutating func email() -> String {
        let local = "\(firstName()).\(lastName())".lowercased().folding(options: [.diacriticInsensitive], locale: nil)
        return "\(local)\(int(in: 1...999))@example.com"
    }

    /// A date between `start` and `end` (in either order). Non-finite intervals give `start`.
    public mutating func date(between start: Date, and end: Date) -> Date {
        let lower = min(start.timeIntervalSinceReferenceDate, end.timeIntervalSinceReferenceDate)
        let upper = max(start.timeIntervalSinceReferenceDate, end.timeIntervalSinceReferenceDate)
        guard lower.isFinite, upper.isFinite, upper - lower <= Double.greatestFiniteMagnitude else { return start }
        return Date(timeIntervalSinceReferenceDate: lower == upper ? lower : Double.random(in: lower...upper, using: &generator))
    }

    static let firstNames = [
        "Ada", "Amara", "Aiko", "Carlos", "Chen", "Elif", "Farah", "Ines", "Jonas", "Kofi",
        "Leila", "Mateo", "Mei", "Nadia", "Omar", "Priya", "Ravi", "Sofia", "Tariq", "Yuki"
    ]

    static let lastNames = [
        "Andersen", "Costa", "Demir", "Fischer", "García", "Haddad", "Ivanova", "Kim", "Mensah",
        "Moreau", "Nakamura", "Novak", "Okafor", "Patel", "Rossi", "Santos", "Silva", "Tanaka", "Wang", "Yilmaz"
    ]
}
