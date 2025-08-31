import SwiftUI
import SFSafeSymbols

struct LimitedGachaOverview: View {
    @ObservedObject var currency: GameCurrency
    @State private var timeRemaining: Int = 1800 // 30 minutes in seconds
    @State private var showDropRates = false
    @State private var offerExpired = false
    @State private var showInsufficientFunds = false
    @State private var navigateToShopOpening = false
    @State private var selectedPullCount = 1
    @State private var selectedCurrency = "gems"
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool // Add this binding for communication with parent
    @State private var navigateToHomeScreen = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("HomeScreenDungeon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 2)
                    .edgesIgnoringSafeArea(.all)
                
                // Close button
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isPresented = false // Use binding instead of dismiss()
                        }) {
                            Image(systemSymbol: .xmark)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(Color.black.opacity(0.6)))
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        // Title
                        Text("Gacha Shop")
                            .font(.custom("Enchanted Land", size: 60))
                            .foregroundStyle(Color.white)
                        
                        // Limited time offer section
                        VStack(spacing: 16) {
                            Text("Limitiertes Angebot")
                                .font(.title2.bold())
                                .foregroundStyle(Color.white)
                            
                            if !offerExpired {
                                // Time remaining display
                                VStack(spacing: 8) {
                                    Text("Dieses Angebot endet in:")
                                        .font(.headline)
                                        .foregroundStyle(Color.white)
                                    
                                    Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60)) Min")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundStyle(Color.white)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.7))
                                        )
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                                
                                // Offer card - pass isPresented binding
                                LimitedTimeOfferCard(
                                    currency: currency,
                                    isPresented: $isPresented,
                                    onPull: {
                                        selectedPullCount = 10
                                        selectedCurrency = "gems"
                                        navigateToShopOpening = true
                                    }
                                )
                                
                                // Transparent drop rate information
                                VStack(spacing: 12) {
                                    Text("Du hast in diesem Zeitraum eine 5% höhere Chance auf legendäre Skills – basierend auf den regulären Wahrscheinlichkeiten von 2%.")
                                        .foregroundStyle(Color.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    Button(action: {
                                        showDropRates = true
                                    }) {
                                        HStack {
                                            Image(systemSymbol: .infoCircle)
                                            Text("Dropchancen einsehen")
                                        }
                                        .foregroundStyle(Color.white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.8))
                                        )
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(0.5))
                                )
                            } else {
                                // Expired offer message
                                VStack(spacing: 15) {
                                    Image(systemSymbol: .clockBadgeExclamationmark)
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                    
                                    Text("Dieses Angebot ist beendet.")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    
                                    Text("Es wird demnächst neue Aktionen geben.")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(30)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.6))
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    offerExpired = true
                }
            }
            .sheet(isPresented: $showDropRates) {
                DropRatesView(
                    isLimitedOffer: true,
                    normalLegendaryChance: "2%",
                    normalEpicChance: "15%",
                    normalRareChance: "33%",
                    normalCommonChance: "50%",
                    limitedLegendaryChance: "7%",
                    limitedEpicChance: "18%",
                    limitedRareChance: "30%",
                    limitedCommonChance: "45%"
                )
            }
            .alert("Nicht genügend Gems", isPresented: $showInsufficientFunds) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Du benötigst Gems für dieses Angebot. Aktuell hast du \(currency.gems) Gems.")
            }
            .navigationDestination(isPresented: $navigateToShopOpening) {
                ShopOpeningView(
                    pullCount: selectedPullCount,
                    currency: selectedCurrency,
                    currencyManager: currency
                )
            }
            .navigationDestination(isPresented: $navigateToHomeScreen) {
                HomeScreenView(ViewState: .constant(0))
            }
        }
    }
}

// MARK: - Limited Time Offer Card for this view
struct LimitedTimeOfferCard: View {
    @ObservedObject var currency: GameCurrency
    @State private var showInsufficientFunds = false
    @State private var navigateToShop = false
    @Binding var isPresented: Bool // Use binding instead of DismissAction
    let onPull: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        colors: [.indigo.opacity(0.8), .purple.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 5)
            
            VStack(spacing: 16) {
                Image("02") // Using a placeholder image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .shadow(radius: 3)
                
                Text("Legendäres Skill-Paket")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("Erhöhte Chance auf seltene Skills!")
                    .foregroundColor(.white.opacity(0.9))
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: GachaShopView(viewState: .constant(0), currency: currency)) {
                        HStack {
                            Text("Jetzt zum Shop")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(currency.gems >= 1000 ? Color.blue : Color.gray)
                        )
                    }
                    
                    Spacer()
                }
                .padding(.top, 8)
                
                Button(action: {
                    isPresented = false // Use binding to close the view
                }) {
                    HStack {
                        Image(systemSymbol: .xmarkCircle)
                        Text("Zurück zum Hauptmenü")
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.4))
                    )
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .frame(height: 340) // Increased height to accommodate the close button
        .padding(.horizontal)
        .alert("Nicht genügend Gems", isPresented: $showInsufficientFunds) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Du benötigst 1000 Gems für dieses Angebot. Aktuell hast du \(currency.gems) Gems.")
        }
    }
}

#Preview {
    LimitedGachaOverview(currency: GameCurrency.shared, isPresented: .constant(true))
}
