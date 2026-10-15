#if canImport(XCTest)
import XCTest
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
import UniformTypeIdentifiers
#endif

/// Enters a secret by pasting it, because `XCUIElement.typeText(_:)` names its own activity
/// after the typed text (`Type 'correct-horse-batt...' into …`), and that name is written to
/// the test log and the result bundle where no redactor can reach it. A paste is logged as
/// `Type 'v' key (Command)`.
///
/// The secret is put on the pasteboard for this device only (no Universal Clipboard) and the
/// pasteboard is emptied right after the paste. Whatever was on the pasteboard before is not
/// restored: reading it back would show a paste-permission prompt on iOS.
@MainActor
enum SecretPasteboard {
    private static let pasteAttempts = 3
    private static let retryInterval: TimeInterval = 1.5

    /// Whether this platform can paste with ⌘V in a UI test.
    static var isAvailable: Bool {
        #if os(macOS) || os(iOS)
        return true
        #else
        return false
        #endif
    }

    /// Pastes `secret` into `element`, which must already have keyboard focus.
    ///
    /// - Returns: Whether the element's value changed; `false` also when the secret could not
    ///   be put on the pasteboard. `nil` when the value is not text, so the paste cannot be
    ///   confirmed.
    static func paste(_ secret: String, into element: XCUIElement, timeout: TimeInterval) -> Bool? {
        #if os(macOS) || os(iOS)
        let before = element.value as? String
        put(secret)
        // The app reads the pasteboard after `typeKey` returns, so the pasteboard is emptied
        // only once the field shows the change (or, for a field without a text value, once
        // reading the value has waited for the app to be idle).
        defer { clear() }
        // Check that the write took effect. Asking whether the pasteboard has text does not
        // read the text, so it shows no paste prompt.
        guard holdsText() else { return false }
        guard let before else {
            element.typeKey("v", modifierFlags: .command)
            _ = element.value
            return nil
        }
        // On the iOS simulator a ⌘V right after the app launches is sometimes dropped. A paste
        // is repeated only while the field's value is still unchanged after `retryInterval`;
        // a paste that arrives that late would show up as the secret entered twice.
        for attempt in 1...pasteAttempts {
            element.typeKey("v", modifierFlags: .command)
            let wait = attempt < pasteAttempts ? min(retryInterval, timeout) : timeout
            if element.waitForValueChange(from: before, timeout: wait) { return true }
        }
        return false
        #else
        return nil
        #endif
    }

    #if os(macOS)
    private static func put(_ secret: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.prepareForNewContents(with: .currentHostOnly)
        pasteboard.setString(secret, forType: .string)
    }

    private static func holdsText() -> Bool {
        NSPasteboard.general.types?.contains(.string) == true
    }

    private static func clear() {
        NSPasteboard.general.clearContents()
    }
    #elseif os(iOS)
    // Long enough for one paste; the item is removed right after the paste anyway.
    private static let lifetime: TimeInterval = 60

    private static func put(_ secret: String) {
        UIPasteboard.general.setItems(
            [[UTType.utf8PlainText.identifier: secret]],
            options: [.localOnly: true, .expirationDate: Date().addingTimeInterval(lifetime)]
        )
    }

    private static func holdsText() -> Bool {
        UIPasteboard.general.hasStrings
    }

    private static func clear() {
        UIPasteboard.general.items = []
    }
    #endif
}
#endif
