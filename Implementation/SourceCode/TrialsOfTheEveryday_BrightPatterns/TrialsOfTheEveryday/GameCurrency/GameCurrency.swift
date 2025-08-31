import SwiftUI
import Combine
import SFSafeSymbols

class GameCurrency: ObservableObject {
    @AppStorage("gems") var gems: Int = 1500
    @AppStorage("coins") var coins: Int = 785
    @AppStorage("stamina") var stamina: Int = 10
    
    static let shared = GameCurrency()
    
    func canAfford(amount: Int, currency: String) -> Bool {
        if currency == "gems" {
            return gems >= amount
        } else if currency == "coins" {
            return coins >= amount
        }
        return false
    }
    
    func deduct(amount: Int, currency: String) {
        if currency == "gems" {
            gems -= amount
        } else if currency == "coins" {
            coins -= amount
        }
    }
}

// MARK: - Currency requirements for pulls
struct PullCosts {
    static let singlePullGems = 50
    static let tenPullGems = 450
    static let singlePullCoins = 500
    static let tenPullCoins = 4500
}

// Reusable alert view for insufficient funds
struct InsufficientFundsAlert: View {
    @Binding var isPresented: Bool
    let currency: String
    var onBuyMore: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Nicht genug \(currency == "gems" ? "Gems" : "Münzen")")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Image(systemSymbol: currency == "gems" ? .diamondCircle : .centsignCircle)
                    .font(.system(size: 50))
                    .foregroundColor(currency == "gems" ? .purple : .yellow)
                
                Text("Du hast nicht genug \(currency == "gems" ? "Gems" : "Münzen") für diesen Kauf.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                HStack(spacing: 15) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Abbrechen")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        onBuyMore()
                        isPresented = false
                    }) {
                        Text("\(currency == "gems" ? "Gems" : "Münzen") kaufen")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(currency == "gems" ? Color.purple : Color.yellow)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(25)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.9))
                    .shadow(color: .black.opacity(0.5), radius: 10)
            )
            .padding(.horizontal, 30)
        }
        .transition(.opacity)
    }
}

// Extension to GachaOptionCard to handle pulling
extension GachaOptionCard {
    var pullCost: Int {
        if currency == "gems" {
            return title.contains("1x") ? PullCosts.singlePullGems : PullCosts.tenPullGems
        } else {
            return title.contains("1x") ? PullCosts.singlePullCoins : PullCosts.tenPullCoins
        }
    }
    
    func handlePull(currencyManager: GameCurrency,
                    showInsufficientFunds: Binding<Bool>,
                    selectedCurrency: Binding<String>,
                    navigateToShopOpening: Binding<Bool>) {
        
        if currencyManager.canAfford(amount: cost, currency: currency) {
            currencyManager.deduct(amount: cost, currency: currency)
            navigateToShopOpening.wrappedValue = true
        } else {
            selectedCurrency.wrappedValue = currency
            showInsufficientFunds.wrappedValue = true
        }
    }
}
