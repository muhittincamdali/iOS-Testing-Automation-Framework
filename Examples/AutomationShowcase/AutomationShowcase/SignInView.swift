import SwiftUI

struct SignInView: View {
    @Environment(Shop.self) private var shop
    @State private var email = ""
    @State private var password = ""
    @State private var error: Shop.SignInError?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome back")
                .font(.largeTitle.bold())
            Text("Sign in to see the catalog.")
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .fieldStyle()
                    .accessibilityIdentifier("signIn.email")
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .fieldStyle()
                    .accessibilityIdentifier("signIn.password")
            }

            if let error {
                Text(message(for: error))
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("signIn.error")
            }

            Button {
                error = shop.signIn(email: email, password: password)
            } label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            // The identifier was "loginButton" before the sign-in screen was redesigned; the
            // healing test still uses the old one.
            .accessibilityIdentifier("signIn.submit")

            Spacer()
        }
        .padding(24)
    }

    private func message(for error: Shop.SignInError) -> String {
        switch error {
        case .invalidInput: "Enter an email address and a password of at least 8 characters."
        case .wrongCredentials: "Wrong email or password."
        }
    }
}

private extension View {
    /// A bordered field at least 44 points tall. The first version used `.roundedBorder`, which
    /// is 34 points tall; the accessibility audit in the UI tests reported it.
    func fieldStyle() -> some View {
        padding(.horizontal, 12)
            .frame(minHeight: 44)
            .background(.background, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.quaternary))
    }
}
