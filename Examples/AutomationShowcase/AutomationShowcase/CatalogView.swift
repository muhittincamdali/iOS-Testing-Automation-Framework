import SwiftUI

struct CatalogView: View {
    @Environment(Shop.self) private var shop
    @State private var showsPrices = true
    let frozenClock: Bool

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Show prices", isOn: $showsPrices)
                        .tint(.accentColor)
                        .accessibilityIdentifier("catalog.showPrices")
                    TimelineView(.periodic(from: .now, by: 1)) { context in
                        Text("Updated \(updatedTime(context.date))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("catalog.updated")
                    }
                }
                Section("Brewing gear") {
                    ForEach(Shop.products) { product in
                        NavigationLink(value: product) {
                            ProductRow(product: product, showsPrice: showsPrices)
                        }
                        .accessibilityIdentifier("product.\(product.id)")
                    }
                }
            }
            .navigationTitle("Catalog")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Cart: \(shop.cart.count)")
                        .accessibilityIdentifier("cart.count")
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out") { shop.signOut() }
                        .accessibilityIdentifier("catalog.signOut")
                }
            }
        }
    }

    private func updatedTime(_ date: Date) -> String {
        let shown = frozenClock ? Date(timeIntervalSince1970: 1_760_000_000) : date
        return shown.formatted(.dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits).second(.twoDigits))
    }
}

struct ProductRow: View {
    let product: Product
    let showsPrice: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: product.symbol)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 32)
                .accessibilityHidden(true)
            Text(product.name)
            Spacer()
            if showsPrice {
                Text(product.price, format: .currency(code: "EUR"))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

struct ProductDetailView: View {
    @Environment(Shop.self) private var shop
    let product: Product

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: product.symbol)
                .font(.system(size: 72))
                .foregroundStyle(.tint)
                .accessibilityLabel(product.name)
            Text(product.price, format: .currency(code: "EUR"))
                .font(.title2.monospacedDigit())
                .accessibilityIdentifier("detail.price")
            Button {
                shop.add(product)
            } label: {
                Text("Add to Cart")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("detail.addToCart")
            Spacer()
        }
        .padding(24)
        .navigationTitle(product.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Cart: \(shop.cart.count)")
                    .accessibilityIdentifier("cart.count")
            }
        }
    }
}
