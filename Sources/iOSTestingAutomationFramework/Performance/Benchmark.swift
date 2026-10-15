import Foundation

/// Summary statistics of a list of measurements.
public struct SampleStatistics: Sendable, Hashable, Codable {
    public let count: Int
    public let minimum: Double
    public let maximum: Double
    public let mean: Double
    public let median: Double
    /// The sample standard deviation (n − 1), 0 for a single value.
    public let standardDeviation: Double
    private let sorted: [Double]

    /// Returns `nil` when `values` has no finite number. NaN and infinite values are dropped.
    public init?(_ values: [Double]) {
        let finite = values.filter(\.isFinite).sorted()
        guard let first = finite.first, let last = finite.last else { return nil }
        sorted = finite
        count = finite.count
        minimum = first
        maximum = last
        // Divide each value before adding so the sum of large values cannot overflow to infinity.
        mean = finite.reduce(0) { $0 + $1 / Double(finite.count) }
        median = Self.percentile(50, of: finite)
        if finite.count > 1 {
            let mean = self.mean
            let variance = finite.reduce(0) { $0 + ($1 - mean) * ($1 - mean) / Double(finite.count - 1) }
            standardDeviation = variance.isFinite ? variance.squareRoot() : .infinity
        } else {
            standardDeviation = 0
        }
    }

    /// The value below which `percent` percent of the measurements fall, with linear
    /// interpolation. `percent` is clamped to 0...100; NaN returns `nil`.
    public func percentile(_ percent: Double) -> Double? {
        guard !percent.isNaN else { return nil }
        return Self.percentile(min(max(percent, 0), 100), of: sorted)
    }

    private enum CodingKeys: String, CodingKey {
        case count, minimum, maximum, mean, median, standardDeviation, sorted
    }

    /// Decodes the measurements and recomputes everything else from them through
    /// ``init(_:)``, so decoded statistics are always consistent. Throws when there is no
    /// finite measurement, which `init(_:)` rejects.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decode([Double].self, forKey: .sorted)
        guard let statistics = SampleStatistics(values) else {
            throw DecodingError.dataCorruptedError(
                forKey: .sorted, in: container,
                debugDescription: "SampleStatistics needs at least one finite measurement"
            )
        }
        self = statistics
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(minimum, forKey: .minimum)
        try container.encode(maximum, forKey: .maximum)
        try container.encode(mean, forKey: .mean)
        try container.encode(median, forKey: .median)
        try container.encode(standardDeviation, forKey: .standardDeviation)
        try container.encode(sorted, forKey: .sorted)
    }

    private static func percentile(_ percent: Double, of sorted: [Double]) -> Double {
        let position = percent / 100 * Double(sorted.count - 1)
        let lower = Int(position.rounded(.down))
        let upper = min(lower + 1, sorted.count - 1)
        let fraction = position - Double(lower)
        return sorted[lower] + (sorted[upper] - sorted[lower]) * fraction
    }
}

/// The measurements of one ``Benchmark`` run.
public struct BenchmarkResult: Sendable, Hashable {
    public let label: String
    /// The duration of each measured iteration, warm-up excluded.
    public let samples: [Duration]
    /// Statistics in seconds.
    public let statistics: SampleStatistics

    /// The median duration.
    public var median: Duration { .seconds(statistics.median) }
    /// The 95th-percentile duration.
    public var p95: Duration { .seconds(statistics.percentile(95) ?? statistics.maximum) }

    /// Whether the median is above `budget`.
    public func exceeds(median budget: Duration) -> Bool { median > budget }

    /// One line such as `decode feed: median 1.204 ms, p95 1.530 ms, min 1.100 ms, max 1.700 ms (n = 20)`.
    public var summary: String {
        let milliseconds = { (seconds: Double) in String(format: "%.3f ms", seconds * 1000) }
        return "\(label): median \(milliseconds(statistics.median)), p95 \(milliseconds(statistics.percentile(95) ?? 0)), "
            + "min \(milliseconds(statistics.minimum)), max \(milliseconds(statistics.maximum)) (n = \(statistics.count))"
    }
}

/// Measures how long code takes, with warm-up runs and statistics that are robust to the
/// occasional slow iteration.
///
/// ```swift
/// let result = try await Benchmark.measure("decode feed", iterations: 20) {
///     _ = try JSONDecoder().decode(Feed.self, from: data)
/// }
/// #expect(!result.exceeds(median: .milliseconds(5)), "\(result.summary)")
/// ```
///
/// Prefer the median or p95 over the mean in assertions: one iteration interrupted by the
/// system moves the mean a lot and the median hardly at all. Run benchmarks in release
/// builds when the numbers matter; debug builds are many times slower.
public enum Benchmark {
    /// The largest number of measured iterations.
    public static let maximumIterations = 100_000
    /// The largest number of warm-up iterations.
    public static let maximumWarmup = 1_000

    /// Measures `body` `iterations` times after `warmup` unmeasured runs.
    ///
    /// `iterations` is clamped to 1...``maximumIterations`` and `warmup` to
    /// 0...``maximumWarmup``.
    public static func measure(
        _ label: String,
        iterations: Int = 10,
        warmup: Int = 1,
        isolation: isolated (any Actor)? = #isolation,
        _ body: () async throws -> Void
    ) async rethrows -> BenchmarkResult {
        let clock = ContinuousClock()
        let iterations = min(max(iterations, 1), maximumIterations)
        for _ in 0..<min(max(warmup, 0), maximumWarmup) {
            try await body()
        }
        var samples: [Duration] = []
        samples.reserveCapacity(iterations)
        for _ in 0..<iterations {
            let start = clock.now
            try await body()
            samples.append(start.duration(to: clock.now))
        }
        return result(label: label, samples: samples)
    }

    /// Builds a result from durations you measured yourself. Negative durations count as zero.
    public static func result(label: String, samples: [Duration]) -> BenchmarkResult {
        let seconds = samples.map { max(RetryPolicy.seconds($0), 0) }
        let statistics = SampleStatistics(seconds.isEmpty ? [0] : seconds) ?? SampleStatistics.zero
        return BenchmarkResult(label: label, samples: samples, statistics: statistics)
    }
}

extension SampleStatistics {
    /// Statistics of the single value 0.
    static let zero = SampleStatistics(count: 1, minimum: 0, maximum: 0, mean: 0, median: 0, standardDeviation: 0, sorted: [0])

    private init(count: Int, minimum: Double, maximum: Double, mean: Double, median: Double, standardDeviation: Double, sorted: [Double]) {
        self.count = count
        self.minimum = minimum
        self.maximum = maximum
        self.mean = mean
        self.median = median
        self.standardDeviation = standardDeviation
        self.sorted = sorted
    }
}
