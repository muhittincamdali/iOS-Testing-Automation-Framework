import SwiftUI

// The README's quick start puts this view in a new app's ContentView.swift; the example app shows
// it with the launch arguments `-screen quickStart`, and QuickStartTests drives it.
struct ContentView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Tapped \(count) times")
                .accessibilityIdentifier("counter.label")
            Button("Tap me") { count += 1 }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("counter.button")
        }
    }
}
