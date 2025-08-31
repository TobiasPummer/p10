import SwiftUI
import SFSafeSymbols

// MARK: - Premium Subscription Management
struct GachaPremiumManager {
    static let monthlyPrice = 4.99
}

// MARK: - Gacha Shop View
struct GachaShopView: View {
    @AppStorage("isPremiumActive") private var isPremiumActive = false
    @State private var showPremiumActivation = false
    @State private var showInsufficientFunds = false
    @State private var selectedCurrency = "gems"
    @Binding var viewState: Int
    @ObservedObject var currency: GameCurrency

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Gacha Shop")
                        .font(.custom("Enchanted Land", size: 60))
                        .foregroundStyle(Color.white)

                    // Premium promotion only if not active
                    if !isPremiumActive {
                        PremiumPromotionCard(showActivation: $showPremiumActivation)
                    }

                    // Gem section
                    Text("Mit Gems ziehen")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Gem pull options
                    GachaOptionCard(
                        title: "1x Pull",
                        cost: PullCosts.singlePullGems,
                        currency: "gems",
                        available: currency.gems,
                        currencyManager: currency,
                        showInsufficientFunds: $showInsufficientFunds,
                        selectedCurrency: $selectedCurrency
                    )

                    GachaOptionCard(
                        title: "10x Pull",
                        cost: PullCosts.tenPullGems,
                        currency: "gems",
                        available: currency.gems,
                        currencyManager: currency,
                        showInsufficientFunds: $showInsufficientFunds,
                        selectedCurrency: $selectedCurrency
                    )

                    // Coin section
                    Text("Mit Münzen ziehen")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)

                    // Coin pull options
                    GachaOptionCard(
                        title: "1x Pull",
                        cost: PullCosts.singlePullCoins,
                        currency: "coins",
                        available: currency.coins,
                        currencyManager: currency,
                        showInsufficientFunds: $showInsufficientFunds,
                        selectedCurrency: $selectedCurrency
                    )

                    GachaOptionCard(
                        title: "10x Pull",
                        cost: PullCosts.tenPullCoins,
                        currency: "coins",
                        available: currency.coins,
                        currencyManager: currency,
                        showInsufficientFunds: $showInsufficientFunds,
                        selectedCurrency: $selectedCurrency
                    )

                    Spacer(minLength: 0)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationDestination(isPresented: $showPremiumActivation) {
                ActivatePremiumView(currency: currency)
            }

            // Show insufficient funds alert when needed
            if showInsufficientFunds {
                InsufficientFundsAlert(
                    isPresented: $showInsufficientFunds,
                    currency: selectedCurrency
                ) {
                    // Handle "Buy more" action here
                    // This would navigate to a store or similar
                }
            }
        }
        .background(
            Image("HomeScreenDungeon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 2)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

// MARK: - Premium Promotion Card
struct PremiumPromotionCard: View {
    @Binding var showActivation: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(
                    colors: [.purple.opacity(0.7), .blue.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(radius: 5)

            VStack(spacing: 12) {
                Text("✨ Gacha Premium ✨")
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Text("Jeden Monat 10x gratis ziehen!")
                    .foregroundColor(.white)

                Button(action: {
                    showActivation = true
                }) {
                    Text("Jetzt aktivieren")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.top, 5)
            }
            .padding()
        }
        .frame(height: 180)
    }
}

// MARK: - Regular Gacha Option Card
struct GachaOptionCard: View {
    let title: String
    let cost: Int
    let currency: String // "gems" or "coins"
    let available: Int
    @ObservedObject var currencyManager: GameCurrency
    @State private var navigateToShopOpening = false
    @Binding var showInsufficientFunds: Bool
    @Binding var selectedCurrency: String

    var pullCount: Int {
        return title.contains("1x") ? 1 : 10
    }

    var buttonColor: Color {
        if available < cost {
            return Color.gray
        } else {
            return currency == "gems" ? Color.purple : Color.yellow
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.7))
                .shadow(radius: 3)

            HStack {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.white)

                Spacer()

                HStack(spacing: 4) {
                    Text("\(cost)")
                    if currency == "gems" {
                        Image(systemSymbol: .diamondCircle)
                            .foregroundStyle(Color.purple)
                    } else {
                        Image(systemSymbol: .centsignCircle)
                            .foregroundStyle(Color.yellow)
                    }
                }
                .foregroundColor(.white)

                NavigationLink(destination: ShopOpeningView(
                    pullCount: pullCount,
                    currency: currency,
                    currencyManager: currencyManager
                ), isActive: $navigateToShopOpening) {
                    EmptyView()
                }

                Button(action: {
                    if currencyManager.canAfford(amount: cost, currency: currency) {
                        currencyManager.deduct(amount: cost, currency: currency)
                        navigateToShopOpening = true
                    } else {
                        selectedCurrency = currency
                        showInsufficientFunds = true
                    }
                }) {
                    Text("Ziehen")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(buttonColor)
                        .cornerRadius(10)
                }
                .disabled(available < cost)
            }
            .padding(.horizontal)
        }
        .frame(height: 70)
    }
}

// MARK: - Activate Premium View
struct ActivatePremiumView: View {
    @AppStorage("isPremiumActive") private var isPremiumActive = false
    @ObservedObject var currency: GameCurrency
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 25) {
            Text("Gacha Premium")
                .font(.title.bold())
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 15) {
                premiumBenefitRow(icon: "gift", text: "Jeden Monat ein kostenloser 10x Pull")
                premiumBenefitRow(icon: "dollarsign.circle", text: "Spare bis zu 450 Gems monatlich")
                premiumBenefitRow(icon: "star", text: "Exklusive Premium-Events")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.6))
            )

            Text("Nur €\(String(format: "%.2f", GachaPremiumManager.monthlyPrice))/Monat")
                .font(.title3.bold())
                .foregroundColor(.white)

            Button(action: {
                activatePremium()
                dismiss()
            }) {
                Text("Jetzt aktivieren")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.top, 10)

            Button("Zurück") {
                dismiss()
            }
            .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("HomeScreenDungeon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 2)
                .edgesIgnoringSafeArea(.all)
        )
    }

    private func premiumBenefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)

            Text(text)
                .foregroundColor(.white)
        }
    }

    private func activatePremium() {
        isPremiumActive = true
        // Add logic to handle first free pull
    }
}
