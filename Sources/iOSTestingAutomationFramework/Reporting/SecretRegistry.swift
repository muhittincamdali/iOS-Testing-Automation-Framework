import Foundation

extension TestingAutomation {
    private static let secretStore = SecretStore()

    /// Registers text that must never appear in activity names, failure messages or reports,
    /// such as a test account's password.
    ///
    /// `Robot.typeSecret(_:into:)` registers what it types. Register other secrets yourself,
    /// for example a token read from the environment.
    public static func registerSecret(_ secret: String) {
        secretStore.register(secret)
    }

    /// A redactor that masks every registered secret and the common credential patterns.
    /// ``TestResultCollector`` and the robots use it for everything they write.
    public static var redactor: Redactor {
        secretStore.redactor
    }

    /// Forgets the registered secrets.
    public static func removeAllSecrets() {
        secretStore.reset()
    }
}

private final class SecretStore: @unchecked Sendable {
    // `value` is only read and written while holding `lock`.
    private let lock = NSLock()
    private var value = Redactor()

    func register(_ secret: String) {
        lock.withLock { value.register(secret) }
    }

    var redactor: Redactor {
        lock.withLock { value }
    }

    func reset() {
        lock.withLock { value = Redactor() }
    }
}
