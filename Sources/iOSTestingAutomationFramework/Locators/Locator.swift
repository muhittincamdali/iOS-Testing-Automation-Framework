/// Describes the element a test is looking for: its accessibility identifier plus the facts a
/// person would use to find it if the identifier changed.
///
/// ```swift
/// let signIn = Locator("signIn.submit", label: "Sign In", kind: .button)
/// ```
public struct Locator: Hashable, Sendable, Codable, CustomStringConvertible {
    /// The accessibility identifier the test expects.
    public var identifier: String
    /// Labels the element is known to show, tried in order when the identifier is missing.
    public var labels: [String]
    /// The placeholder of a text field, used when the identifier and labels are missing.
    public var placeholder: String?
    /// Restricts every strategy to elements of this kind.
    public var kind: ElementKind?

    public init(_ identifier: String, labels: [String] = [], placeholder: String? = nil, kind: ElementKind? = nil) {
        self.identifier = identifier
        self.labels = labels
        self.placeholder = placeholder
        self.kind = kind
    }

    public init(_ identifier: String, label: String, placeholder: String? = nil, kind: ElementKind? = nil) {
        self.init(identifier, labels: [label], placeholder: placeholder, kind: kind)
    }

    public var description: String {
        var parts = ["id: \(identifier)"]
        if !labels.isEmpty { parts.append("labels: \(labels.joined(separator: ", "))") }
        if let placeholder { parts.append("placeholder: \(placeholder)") }
        if let kind { parts.append("kind: \(kind)") }
        return "Locator(\(parts.joined(separator: "; ")))"
    }
}
