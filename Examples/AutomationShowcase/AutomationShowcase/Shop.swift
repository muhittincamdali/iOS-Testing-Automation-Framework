import Foundation
import Observation

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Decimal
    let symbol: String
}

/// The app's state: who is signed in and what is in the cart.
@MainActor
@Observable
final class Shop {
    /// The only account the sample accepts.
    static let demoEmail = "ada@example.com"
    static let demoPassword = "correct-horse-battery"

    static let products = [
        Product(id: "kettle", name: "Pour-over kettle", price: 39, symbol: "cup.and.saucer"),
        Product(id: "grinder", name: "Hand grinder", price: 64, symbol: "gearshape.2"),
        Product(id: "scale", name: "Coffee scale", price: 28, symbol: "scalemass"),
        Product(id: "filters", name: "Paper filters", price: 6, symbol: "doc.on.doc")
    ]

    private(set) var isSignedIn = false
    private(set) var cart: [Product] = []

    enum SignInError: Equatable {
        case invalidInput
        case wrongCredentials
    }

    /// Checks the form and signs in the demo account.
    func signIn(email: String, password: String) -> SignInError? {
        let email = email.trimmingCharacters(in: .whitespaces)
        guard email.contains("@"), email.contains("."), password.count >= 8 else { return .invalidInput }
        guard email.lowercased() == Self.demoEmail, password == Self.demoPassword else { return .wrongCredentials }
        isSignedIn = true
        return nil
    }

    func add(_ product: Product) {
        cart.append(product)
    }

    func signOut() {
        isSignedIn = false
        cart = []
    }
}
