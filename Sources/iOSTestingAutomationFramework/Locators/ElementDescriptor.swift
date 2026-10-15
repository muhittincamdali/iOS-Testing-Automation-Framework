import CoreGraphics

/// The kind of a user interface element, such as a button or a text field.
///
/// The predefined values match `XCUIElement.ElementType` names. The type is open, so a value
/// such as `ElementKind("map")` also works.
public struct ElementKind: RawRepresentable, Hashable, Sendable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }
    public init(_ rawValue: String) { self.rawValue = rawValue }
    public init(stringLiteral value: String) { self.rawValue = value }

    public var description: String { rawValue }

    public static let any: ElementKind = "any"
    public static let other: ElementKind = "other"
    public static let application: ElementKind = "application"
    public static let window: ElementKind = "window"
    public static let button: ElementKind = "button"
    public static let link: ElementKind = "link"
    public static let staticText: ElementKind = "staticText"
    public static let image: ElementKind = "image"
    public static let icon: ElementKind = "icon"
    public static let textField: ElementKind = "textField"
    public static let secureTextField: ElementKind = "secureTextField"
    public static let searchField: ElementKind = "searchField"
    public static let textView: ElementKind = "textView"
    public static let toggle: ElementKind = "toggle"
    public static let `switch`: ElementKind = "switch"
    public static let slider: ElementKind = "slider"
    public static let stepper: ElementKind = "stepper"
    public static let picker: ElementKind = "picker"
    public static let segmentedControl: ElementKind = "segmentedControl"
    public static let menuItem: ElementKind = "menuItem"
    public static let tab: ElementKind = "tab"
    public static let cell: ElementKind = "cell"
    public static let navigationBar: ElementKind = "navigationBar"
    public static let tabBar: ElementKind = "tabBar"
    public static let toolbar: ElementKind = "toolbar"
    public static let scrollView: ElementKind = "scrollView"
    public static let table: ElementKind = "table"
    public static let collectionView: ElementKind = "collectionView"

    /// Kinds that a person activates or edits. The accessibility audit expects these to have a
    /// label and a large enough touch target.
    public static let interactive: Set<ElementKind> = [
        .button, .link, .textField, .secureTextField, .searchField, .textView, .toggle, .switch,
        .slider, .stepper, .picker, .segmentedControl, .menuItem, .tab
    ]

    /// Whether elements of this kind are in ``interactive``.
    public var isInteractive: Bool { Self.interactive.contains(self) }
}

/// A plain-value copy of one element in the user interface tree.
///
/// The XCUITest layer creates descriptors from `XCUIElement.snapshot()`; the locator healer
/// and the accessibility audit work on descriptors, so their rules can be tested without a
/// running app.
public struct ElementDescriptor: Hashable, Sendable, Codable {
    public var kind: ElementKind
    /// The accessibility identifier. Empty when the element has none.
    public var identifier: String
    /// The accessibility label: what VoiceOver reads.
    public var label: String
    /// The current value as text, for example a text field's content or a switch's `"1"`.
    public var value: String?
    /// The placeholder of a text field.
    public var placeholder: String?
    /// The element's frame in points, in screen coordinates.
    public var frame: CGRect
    public var isEnabled: Bool
    /// How deep the element is in the tree; the root is 0.
    public var depth: Int

    public init(
        kind: ElementKind,
        identifier: String = "",
        label: String = "",
        value: String? = nil,
        placeholder: String? = nil,
        frame: CGRect = .zero,
        isEnabled: Bool = true,
        depth: Int = 0
    ) {
        self.kind = kind
        self.identifier = identifier
        self.label = label
        self.value = value
        self.placeholder = placeholder
        self.frame = frame
        self.isEnabled = isEnabled
        self.depth = depth
    }

    /// A short description for messages, such as `button "Sign In" (id: signIn.submit)`.
    public var summary: String {
        var text = kind.rawValue
        if !label.isEmpty { text += " \"\(label)\"" }
        if !identifier.isEmpty { text += " (id: \(identifier))" }
        if label.isEmpty, identifier.isEmpty, let placeholder, !placeholder.isEmpty {
            text += " (placeholder: \(placeholder))"
        }
        return text
    }
}
