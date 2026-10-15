import Foundation

/// Records the calls to one function of a test double and returns stubbed results.
///
/// Give each method of a fake one spy:
///
/// ```swift
/// final class FakeUserService: UserService {
///     let fetchUser = Spy<Int, User>(returning: User(id: 1, name: "Ada"))
///     func user(id: Int) -> User { fetchUser(id) }
/// }
///
/// let service = FakeUserService()
/// _ = ViewModel(service: service).load(id: 42)
/// #expect(service.fetchUser.inputs == [42])
/// ```
///
/// A spy is safe to call from several threads and tasks at once. It keeps the inputs of the
/// first ``maximumRecordedCalls`` calls (10,000 by default) so a test that calls a fake in a
/// tight loop cannot use unbounded memory; ``callCount`` keeps counting past that limit.
public final class Spy<Input: Sendable, Output: Sendable>: Sendable {
    private let storage: SpyStorage<Input, Output>

    /// The number of inputs kept.
    public var maximumRecordedCalls: Int { storage.maximumRecordedCalls }

    /// Creates a spy that returns `defaultOutput` until it is stubbed.
    public init(returning defaultOutput: Output, maximumRecordedCalls: Int = 10_000) {
        storage = SpyStorage(defaultOutcome: .success(defaultOutput), maximumRecordedCalls: maximumRecordedCalls)
    }

    /// Records the call and returns the stubbed result.
    @discardableResult
    public func callAsFunction(_ input: Input) -> Output {
        // A non-throwing spy only ever stores successful outcomes.
        switch storage.call(input) {
        case .success(let output): return output
        case .failure: preconditionFailure("Spy holds only successful outcomes")
        }
    }

    /// Returns `output` for every following call.
    public func stub(_ output: Output) {
        storage.stub(.always(.success(output)))
    }

    /// Returns the outputs in order, one per call, then repeats the last one.
    /// An empty array is ignored.
    public func stub(sequence outputs: [Output]) {
        guard !outputs.isEmpty else { return }
        storage.stub(.sequence(outputs.map { .success($0) }))
    }

    /// Computes the output from the input.
    public func stub(_ compute: @escaping @Sendable (Input) -> Output) {
        storage.stub(.compute { .success(compute($0)) })
    }

    /// How many times the spy was called, including calls beyond the recording limit.
    public var callCount: Int { storage.callCount }
    /// Whether the spy was called at least once.
    public var wasCalled: Bool { callCount > 0 }
    /// The recorded inputs, oldest first.
    public var inputs: [Input] { storage.inputs }
    /// The most recent recorded input.
    public var lastInput: Input? { storage.inputs.last }

    /// Forgets the calls and the stubs.
    public func reset() { storage.reset() }
}

extension Spy where Input: Equatable {
    /// Whether one of the recorded calls had `input`.
    public func wasCalled(with input: Input) -> Bool { inputs.contains(input) }
    /// How many recorded calls had `input`.
    public func callCount(with input: Input) -> Int { inputs.count { $0 == input } }
}

extension Spy where Output == Void {
    /// Creates a spy for a function that returns nothing.
    public convenience init(maximumRecordedCalls: Int = 10_000) {
        self.init(returning: (), maximumRecordedCalls: maximumRecordedCalls)
    }
}

/// A ``Spy`` for a function that can throw.
///
/// ```swift
/// let save = ThrowingSpy<Note, Void>(returning: ())
/// save.stub(throwing: URLError(.notConnectedToInternet))
/// ```
public final class ThrowingSpy<Input: Sendable, Output: Sendable>: Sendable {
    private let storage: SpyStorage<Input, Output>

    public var maximumRecordedCalls: Int { storage.maximumRecordedCalls }

    public init(returning defaultOutput: Output, maximumRecordedCalls: Int = 10_000) {
        storage = SpyStorage(defaultOutcome: .success(defaultOutput), maximumRecordedCalls: maximumRecordedCalls)
    }

    /// Records the call and returns the stubbed result or throws the stubbed error.
    @discardableResult
    public func callAsFunction(_ input: Input) throws -> Output {
        try storage.call(input).unwrapped()
    }

    public func stub(_ output: Output) {
        storage.stub(.always(.success(output)))
    }

    /// Throws `error` from every following call.
    public func stub(throwing error: any Error) {
        storage.stub(.always(.failure(SendableError(error))))
    }

    /// Plays back the results in order, one per call, then repeats the last one.
    /// An empty array is ignored.
    public func stub(sequence results: [Result<Output, any Error>]) {
        guard !results.isEmpty else { return }
        storage.stub(.sequence(results.map { $0.mapError { SendableError($0) } }))
    }

    public func stub(_ compute: @escaping @Sendable (Input) throws -> Output) {
        storage.stub(.compute { input in
            do { return .success(try compute(input)) } catch { return .failure(SendableError(error)) }
        })
    }

    public var callCount: Int { storage.callCount }
    public var wasCalled: Bool { callCount > 0 }
    public var inputs: [Input] { storage.inputs }
    public var lastInput: Input? { storage.inputs.last }

    public func reset() { storage.reset() }
}

extension ThrowingSpy where Input: Equatable {
    public func wasCalled(with input: Input) -> Bool { inputs.contains(input) }
    public func callCount(with input: Input) -> Int { inputs.count { $0 == input } }
}

extension ThrowingSpy where Output == Void {
    public convenience init(maximumRecordedCalls: Int = 10_000) {
        self.init(returning: (), maximumRecordedCalls: maximumRecordedCalls)
    }
}

// MARK: - Storage

/// Wraps an error so it can be stored in a `Sendable` result. Thrown errors are unwrapped
/// again, so callers see the original error.
struct SendableError: Error, @unchecked Sendable {
    // Errors are values that are not mutated after they are thrown; a stub keeps it unchanged.
    let underlying: any Error
    init(_ error: any Error) { underlying = (error as? SendableError)?.underlying ?? error }
}

private extension Result where Failure == SendableError {
    func unwrapped() throws -> Success {
        switch self {
        case .success(let value): return value
        case .failure(let wrapper): throw wrapper.underlying
        }
    }
}

final class SpyStorage<Input: Sendable, Output: Sendable>: @unchecked Sendable {
    typealias Outcome = Result<Output, SendableError>

    enum Behavior {
        case always(Outcome)
        case sequence([Outcome])
        case compute(@Sendable (Input) -> Outcome)
    }

    // Every access to the state below goes through `lock`.
    private let lock = NSLock()
    private let defaultOutcome: Outcome
    private var behavior: Behavior?
    private var sequenceIndex = 0
    private var recordedInputs: [Input] = []
    private var count = 0
    let maximumRecordedCalls: Int

    init(defaultOutcome: Outcome, maximumRecordedCalls: Int) {
        self.defaultOutcome = defaultOutcome
        self.maximumRecordedCalls = max(0, maximumRecordedCalls)
    }

    func call(_ input: Input) -> Outcome {
        let behavior: Behavior? = lock.withLock {
            count += 1
            if recordedInputs.count < maximumRecordedCalls { recordedInputs.append(input) }
            return self.behavior
        }
        switch behavior {
        case nil:
            return defaultOutcome
        case .always(let outcome):
            return outcome
        case .compute(let compute):
            // Called outside the lock, so a stub may call back into the spy.
            return compute(input)
        case .sequence(let outcomes):
            return lock.withLock {
                let index = min(sequenceIndex, outcomes.count - 1)
                // Stop counting once the last outcome repeats, so the index cannot overflow.
                if sequenceIndex < outcomes.count { sequenceIndex += 1 }
                return outcomes[index]
            }
        }
    }

    func stub(_ behavior: Behavior) {
        lock.withLock {
            self.behavior = behavior
            sequenceIndex = 0
        }
    }

    var callCount: Int { lock.withLock { count } }
    var inputs: [Input] { lock.withLock { recordedInputs } }

    func reset() {
        lock.withLock {
            behavior = nil
            sequenceIndex = 0
            recordedInputs = []
            count = 0
        }
    }
}
