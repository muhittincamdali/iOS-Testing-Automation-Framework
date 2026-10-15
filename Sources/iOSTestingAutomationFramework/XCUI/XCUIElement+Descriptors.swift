#if canImport(XCTest)
import XCTest

extension XCUIElement {
    /// The most elements ``descriptors()`` returns. Larger trees are cut off, which keeps an
    /// audit or a healing lookup on a huge list bounded.
    public static let descriptorLimit = 5_000
    /// The deepest level ``descriptors()`` descends to.
    public static let descriptorDepthLimit = 64

    /// Takes one snapshot of this element and its descendants and returns them as plain
    /// values, parents before children.
    ///
    /// One snapshot is much faster than querying elements one by one, and the result can be
    /// passed to ``LocatorHealer`` and ``AccessibilityAudit``.
    @MainActor
    public func descriptors() throws -> [ElementDescriptor] {
        var result: [ElementDescriptor] = []
        var stack: [(snapshot: any XCUIElementSnapshot, depth: Int)] = [(try snapshot(), 0)]
        while let (node, depth) = stack.popLast(), result.count < Self.descriptorLimit {
            result.append(ElementDescriptor(snapshot: node, depth: depth))
            guard depth < Self.descriptorDepthLimit else { continue }
            // Reverse so children come out of the stack in their on-screen order.
            for child in node.children.reversed() {
                stack.append((child, depth + 1))
            }
        }
        return result
    }
}

extension ElementDescriptor {
    @MainActor
    init(snapshot: any XCUIElementSnapshot, depth: Int) {
        let value: String?
        switch snapshot.value {
        case nil: value = nil
        case let text as String: value = text
        case let number as NSNumber: value = number.stringValue
        case let other?: value = String(describing: other)
        }
        self.init(
            kind: ElementKind(snapshot.elementType),
            identifier: snapshot.identifier,
            label: snapshot.label,
            value: value,
            placeholder: snapshot.placeholderValue,
            frame: snapshot.frame,
            isEnabled: snapshot.isEnabled,
            depth: depth
        )
    }
}

extension ElementKind {
    /// The kind for an XCTest element type. Types without a predefined kind map to ``other``.
    public init(_ type: XCUIElement.ElementType) {
        self = Self.byType[type] ?? .other
    }

    /// The XCTest element type for this kind, or `.any` for kinds XCTest does not have.
    public var elementType: XCUIElement.ElementType {
        Self.byType.first { $0.value == self }?.key ?? .any
    }

    private static let byType: [XCUIElement.ElementType: ElementKind] = [
        .any: .any,
        .other: .other,
        .application: .application,
        .window: .window,
        .button: .button,
        .link: .link,
        .staticText: .staticText,
        .image: .image,
        .icon: .icon,
        .textField: .textField,
        .secureTextField: .secureTextField,
        .searchField: .searchField,
        .textView: .textView,
        .toggle: .toggle,
        .switch: .switch,
        .slider: .slider,
        .stepper: .stepper,
        .picker: .picker,
        .segmentedControl: .segmentedControl,
        .menuItem: .menuItem,
        .tab: .tab,
        .cell: .cell,
        .navigationBar: .navigationBar,
        .tabBar: .tabBar,
        .toolbar: .toolbar,
        .scrollView: .scrollView,
        .table: .table,
        .collectionView: .collectionView
    ]
}
#endif
