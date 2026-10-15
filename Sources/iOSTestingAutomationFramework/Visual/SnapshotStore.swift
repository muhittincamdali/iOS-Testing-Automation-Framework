import Foundation

/// Keeps baseline images on disk and compares new images with them.
///
/// Baselines are PNG files in ``directory``, one per snapshot name. When an image does not
/// match, the actual image and a difference image are written to ``failureDirectory`` so you
/// can open them or upload them as CI artifacts.
///
/// Names are turned into safe file names: only letters, digits, `.`, `-` and `_` are kept, so
/// a name such as `../../secrets` cannot write outside the folder.
public struct SnapshotStore: Sendable {
    /// When to write a new baseline instead of comparing.
    public enum RecordMode: String, Sendable, CaseIterable {
        /// Never record; a missing baseline is a failure. Use this on CI.
        case never
        /// Record a baseline only when none exists (the default).
        case missing
        /// Record every image, replacing existing baselines.
        case all

        /// The environment variable that overrides the record mode of every store:
        /// `TESTING_AUTOMATION_RECORD=all`, `missing` or `never`.
        public static let environmentKey = "TESTING_AUTOMATION_RECORD"

        /// The mode set in the environment, or `nil` if the variable is missing or invalid.
        public static func fromEnvironment(_ environment: [String: String] = ProcessInfo.processInfo.environment) -> RecordMode? {
            environment[environmentKey].flatMap { RecordMode(rawValue: $0.lowercased()) }
        }
    }

    /// The result of ``verify(_:named:comparator:)``.
    public enum Verification: Sendable {
        /// The image matched its baseline.
        case matched(ImageComparison)
        /// A baseline was written to the URL. The image was not compared.
        case recorded(URL)
        /// No baseline exists and the record mode is ``RecordMode/never``.
        case missingBaseline(URL)
        /// The image differs from the baseline at `baseline`. The actual and difference images
        /// were written to the other URLs when that was possible.
        case mismatch(ImageComparison, baseline: URL, actual: URL?, difference: URL?)

        /// True for ``matched(_:)``.
        public var passed: Bool {
            if case .matched = self { return true }
            return false
        }

        /// A message for a test failure, or `nil` when the image matched.
        public var failureMessage: String? {
            switch self {
            case .matched:
                return nil
            case .recorded(let url):
                return "Recorded a new baseline at \(url.path). Run the test again to compare against it."
            case .missingBaseline(let url):
                return "No baseline at \(url.path). Run once with \(RecordMode.environmentKey)=missing to record it."
            case .mismatch(let comparison, let baseline, let actual, let difference):
                var message = "Snapshot does not match \(baseline.lastPathComponent): \(comparison.summary)."
                if let actual { message += "\nActual: \(actual.path)" }
                if let difference { message += "\nDifference: \(difference.path)" }
                return message
            }
        }
    }

    /// The folder that holds the baselines.
    public let directory: URL
    /// Where actual and difference images go when a comparison fails.
    public let failureDirectory: URL
    /// The record mode, after applying `TESTING_AUTOMATION_RECORD` if it is set.
    public let recordMode: RecordMode

    /// Creates a store.
    ///
    /// - Parameters:
    ///   - directory: The folder for baselines.
    ///   - failureDirectory: The folder for failure images. Defaults to a `Failures` folder in
    ///     the system's temporary directory, so test runs do not add files to your sources.
    ///   - recordMode: Overridden by `TESTING_AUTOMATION_RECORD` when that variable is set.
    public init(
        directory: URL,
        failureDirectory: URL? = nil,
        recordMode: RecordMode = .missing,
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) {
        self.directory = directory
        self.failureDirectory = failureDirectory
            ?? FileManager.default.temporaryDirectory.appendingPathComponent("SnapshotFailures", isDirectory: true)
        self.recordMode = RecordMode.fromEnvironment(environment) ?? recordMode
    }

    /// A store in `__Snapshots__/<test file name>/` next to the test file, the layout most
    /// snapshot tools use.
    public static func besideTestFile(
        _ filePath: StaticString = #filePath,
        recordMode: RecordMode = .missing
    ) -> SnapshotStore {
        let file = URL(fileURLWithPath: "\(filePath)")
        let folder = file.deletingLastPathComponent()
            .appendingPathComponent("__Snapshots__", isDirectory: true)
            .appendingPathComponent(file.deletingPathExtension().lastPathComponent, isDirectory: true)
        return SnapshotStore(directory: folder, recordMode: recordMode)
    }

    /// The baseline file for `name`.
    public func baselineURL(for name: String) -> URL {
        directory.appendingPathComponent(Self.fileName(for: name) + ".png", isDirectory: false)
    }

    /// Compares `image` with the baseline called `name`, or records it, depending on
    /// ``recordMode``.
    public func verify(_ image: Bitmap, named name: String, comparator: ImageComparator = ImageComparator()) throws -> Verification {
        let baseline = baselineURL(for: name)
        let exists = FileManager.default.fileExists(atPath: baseline.path)
        if recordMode == .all || (recordMode == .missing && !exists) {
            try image.writePNG(to: baseline)
            return .recorded(baseline)
        }
        guard exists else { return .missingBaseline(baseline) }

        let comparison = comparator.compare(try Bitmap(contentsOf: baseline), image)
        if comparison.matches { return .matched(comparison) }

        let stem = Self.fileName(for: name)
        let actualURL = failureDirectory.appendingPathComponent(stem + ".actual.png")
        let differenceURL = failureDirectory.appendingPathComponent(stem + ".difference.png")
        let wroteActual = (try? image.writePNG(to: actualURL)) != nil
        // nil when there is no difference image (size mismatch) or writing failed.
        let wroteDifference = (try? comparison.differenceImage?.writePNG(to: differenceURL)) != nil
        return .mismatch(
            comparison,
            baseline: baseline,
            actual: wroteActual ? actualURL : nil,
            difference: wroteDifference ? differenceURL : nil
        )
    }

    /// A file name made only of ASCII letters, digits, `.`, `-` and `_`, at most 120
    /// characters, never starting with a dot and never empty.
    public static func fileName(for name: String) -> String {
        var result = ""
        var lastWasSeparator = false
        for scalar in name.unicodeScalars {
            let isSafe = scalar.isASCII && (CharacterSet.alphanumerics.contains(scalar) || scalar == "-" || scalar == "_" || scalar == ".")
            if isSafe {
                result.unicodeScalars.append(scalar)
                lastWasSeparator = false
            } else if !lastWasSeparator {
                result += "-"
                lastWasSeparator = true
            }
        }
        // Remove leading dots and dashes so the name is neither hidden nor `..`.
        while let first = result.first, first == "." || first == "-" { result.removeFirst() }
        while let last = result.last, last == "-" { result.removeLast() }
        if result.count > 120 { result = String(result.prefix(120)) }
        return result.isEmpty ? "snapshot" : result
    }
}
