#if canImport(XCTest)
import XCTest

/// iOSTestingAutomationFramework: Self-Healing Selector Engine.
/// 
/// This engine proactively attempts to recover from broken accessibility identifiers
/// by utilizing multi-layered fallback strategies (Labels, Titles, Hierarchy).
@MainActor
public struct SelfHealingEngine {
    
    /// Finds an element using a primary identifier, with automatic self-healing fallbacks.
    /// - Parameters:
    ///   - query: The base query to search in.
    ///   - primaryID: The expected accessibilityIdentifier.
    ///   - fallbackLabel: Optional text label to use as a fallback.
    ///   - timeout: Time to wait for the primary element before healing.
    /// - Returns: The healed XCUIElement (or the original if healing fails).
    public static func findHealedElement(
        in query: XCUIElementQuery,
        primaryID: String,
        fallbackLabel: String? = nil,
        timeout: TimeInterval = 2.0
    ) -> XCUIElement {
        let primary = query.matching(identifier: primaryID).firstMatch
        
        if primary.waitForExistence(timeout: timeout) {
            return primary
        }
        
        // --- INITIATING SELF-HEALING SEQUENCE ---
        print("🕵️‍♂️ [Resilience] Element ID '\(primaryID)' not found. Attempting self-healing...")
        
        // Fallback 1: Match by Label/Text
        if let label = fallbackLabel {
            let byLabel = query.staticTexts[label].firstMatch
            if byLabel.exists {
                print("⚠️ [Resilience] HEALED: Found element by label '\(label)'. Suggestion: Update ID to match.")
                return byLabel
            }
        }
        
        // Fallback 2: Match by Placeholder (for TextFields)
        let byPlaceholder = query.textFields.matching(NSPredicate(format: "placeholderValue == %@", primaryID)).firstMatch
        if byPlaceholder.exists {
            print("⚠️ [Resilience] HEALED: Found element by placeholderValue. Suggestion: Update ID.")
            return byPlaceholder
        }
        
        // Fallback 3: Fuzzy Match (Partial ID)
        let fuzzyMatch = query.containing(NSPredicate(format: "identifier CONTAINS %@", primaryID)).firstMatch
        if fuzzyMatch.exists {
            print("⚠️ [Resilience] HEALED: Found element via partial ID match.")
            return fuzzyMatch
        }
        
        print("❌ [Resilience] Self-healing failed for ID: \(primaryID)")
        return primary // Return original to allow XCTest to handle the failure normally
    }
}
#endif
