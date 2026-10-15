import SwiftUI

/// A small shop app that the UI tests in AutomationShowcaseUITests drive.
///
/// Launch arguments, set by the tests:
/// - `-screen auditDemo` opens a screen with deliberate accessibility problems.
/// - `-screen quickStart` opens the counter from the README's quick start.
/// - `-colorScheme dark` forces dark appearance for screenshots.
/// - `-frozenClock` shows a fixed "last updated" time instead of the current one.
@main
struct AutomationShowcaseApp: App {
    @State private var shop = Shop()
    private let arguments = LaunchArguments(ProcessInfo.processInfo.arguments)

    var body: some Scene {
        WindowGroup {
            Group {
                if arguments.screen == "auditDemo" {
                    AuditDemoView()
                } else if arguments.screen == "quickStart" {
                    ContentView()
                } else if shop.isSignedIn {
                    CatalogView(frozenClock: arguments.frozenClock)
                } else {
                    SignInView()
                }
            }
            .environment(shop)
            .tint(Color(red: 0, green: 0.443, blue: 0.890))
            .preferredColorScheme(arguments.colorScheme)
        }
    }
}

struct LaunchArguments {
    let screen: String?
    let colorScheme: ColorScheme?
    let frozenClock: Bool

    init(_ arguments: [String]) {
        func value(after flag: String) -> String? {
            guard let index = arguments.firstIndex(of: flag), arguments.indices.contains(index + 1) else { return nil }
            return arguments[index + 1]
        }
        screen = value(after: "-screen")
        switch value(after: "-colorScheme") {
        case "dark": colorScheme = .dark
        case "light": colorScheme = .light
        default: colorScheme = nil
        }
        frozenClock = arguments.contains("-frozenClock")
    }
}
