import SwiftUI

/// A screen with two deliberate accessibility mistakes, so the UI tests can show that the
/// audit finds them. Do not copy this screen.
struct AuditDemoView: View {
    @State private var favorites = 0

    var body: some View {
        VStack(spacing: 24) {
            Text("Audit demo")
                .font(.title.bold())
            HStack {
                Text("Favorites: \(favorites)")
                    .accessibilityIdentifier("audit.favorites")
                // Mistake: a 24 × 24 pt button with no label. VoiceOver can only say "button".
                Button {
                    favorites += 1
                } label: {
                    Circle()
                        .fill(.tint)
                        .frame(width: 24, height: 24)
                }
                .accessibilityIdentifier("audit.favorite")
            }
            Spacer()
        }
        .padding(24)
    }
}
