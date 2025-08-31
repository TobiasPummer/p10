import SwiftUI
import SFSafeSymbols

// Shop Item Model
struct ShopItem: Identifiable {
    let id = UUID()
    let name: String
    let rarity: Rarity
    let imageName: String
    
    enum Rarity: String, CaseIterable {
        case common
        case rare
        case epic
        case legendary
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return .orange
            }
        }
        
        static func random() -> Rarity {
            let randomValue = Double.random(in: 0...1)
            switch randomValue {
            case 0..<0.6: return .common
            case 0.6..<0.75: return .rare
            case 0.75..<0.90: return .epic
            default: return .legendary
            }
        }
    }
}

// Item Generator
class ItemGenerator {
    private let availableItems = [
        "Paladin's Sight",
        "Paladin's Strength",
        "Paladin's Oppression",
        "Paladin's Fight",
        "Paladin's Cry",
        "Paladin's Fist",
        "Paladin's Dash",
        "Paladin's Block",
        "Paladin's Strike",
        "Paladin's 100 Stabs",
        "Paladin's Weapon Break",
        "Paladin's Shield Break",
        "Paladin's Sight",
        "Paladin's Armor",
        "Paladin's Up Defense",
        "Paladin's Smite",
        "Paladin's Buff",
        "Paladin's Enhance"
    ]

    private let imageNames = [
        "passivePaladinsSight",
        "passivePaladinsStrength",
        "passivePaladinsOppresion",
        "passivePaladinsFight",
        "activePaladinsCry",
        "activePaladinsFist",
        "activePaladinsDash",
        "activePaladinsBlock",
        "activePaladinsStrike",
        "activePaladins100Stabs",
        "activePaladinsWeaponBreak",
        "activePaladinsShielBreak",
        "activePaladinsSight",
        "activePaladinsArmor",
        "activePaladinsUpDefense",
        "activePaladinsSmite",
        "activePaladinsBuff",
        "activePaladinsEnhance"
    ]
    
    func generateRandomItem() -> ShopItem {
        let index = Int.random(in: 0..<availableItems.count)
        let name = availableItems[index]
        let imageName = imageNames[index]
        let rarity = ShopItem.Rarity.random()
        
        return ShopItem(name: name, rarity: rarity, imageName: imageName)
    }
    
    func generateMultipleItems(count: Int) -> [ShopItem] {
        return (0..<count).map { _ in generateRandomItem() }
    }
}

struct UnlockItemsAlert: View {
    @Binding var isPresented: Bool
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Glückwunsch!")
                    .font(.title.bold())
                    .foregroundColor(.white)

                Image(systemSymbol: .trophyCircle)
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)

                Text("Du hast neue Items freigeschaltet!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                Button(action: {
                    onContinue()
                    isPresented = false
                }) {
                    Text("Weiter")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
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

// Shop Item View
struct ShopItemView: View {
    let item: ShopItem
    
    var body: some View {
        HStack(spacing: 15) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(item.rarity.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundColor(item.rarity.color)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    colors: [item.rarity.color.opacity(0.2), item.rarity.color.opacity(0.4)],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(item.rarity.color.opacity(0.6), lineWidth: 1)
        )
    }
}

// Shop Opening View
struct ShopOpeningView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentItem: ShopItem? = nil
    @State private var multipleItems: [ShopItem] = []
    @State private var isPulled = false
    @State private var showingItems = false
    @State private var showUnlockAlert = false
    
    // Pull costs
    private let singlePullGems = 50
    private let tenPullGems = 450
    private let singlePullCoins = 500
    private let tenPullCoins = 4500
    
    // Pull count passed from parent view
    var pullCount: Int
    var currency: String // "gems" or "coins"
    @ObservedObject var currencyManager: GameCurrency
    
    private let itemGenerator = ItemGenerator()
    
    var pullButtonColor: Color {
        return currency == "gems" ? Color.purple : Color.yellow
    }
    
    var pullCost: Int {
        if currency == "gems" {
            return pullCount == 1 ? singlePullGems : tenPullGems
        } else {
            return pullCount == 1 ? singlePullCoins : tenPullCoins
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Gacha Shop")
                        .font(.custom("Enchanted Land", size: 60))
                        .foregroundStyle(Color.white)
                        .padding(.top)
                    
                    if !isPulled {
                        VStack {
                            Text(pullCount == 1 ? "1x Pull" : "10x Pull")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .padding()
                            
                            HStack {
                                Image(systemSymbol: currency == "gems" ? .diamondCircle : .centsignCircle)
                                    .foregroundStyle(currency == "gems" ? Color.purple : Color.yellow)
                                    .font(.title2)
                                Text("\(pullCost) \(currency == "gems" ? "Gems" : "Münzen")")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom)
                            
                            Button(action: {
                                performPull()
                            }) {
                                Text("Jetzt ziehen")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 200)
                                    .background(pullButtonColor)
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 20)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.7))
                                .shadow(radius: 5)
                        )
                        .padding(.horizontal)
                    } else {
                        if pullCount == 1, let item = currentItem {
                            // Single item display
                            VStack(spacing: 20) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(LinearGradient(
                                            colors: [item.rarity.color.opacity(0.2), item.rarity.color.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .shadow(color: item.rarity.color, radius: 8)
                                    
                                    VStack {
                                        Image(item.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 180)
                                            .padding(.top)
                                            .glow(color: item.rarity.color, radius: 8)
                                        
                                        Text(item.name)
                                            .font(.title.bold())
                                            .foregroundColor(.white)
                                        
                                        Text(item.rarity.rawValue.capitalized)
                                            .font(.title2)
                                            .foregroundColor(item.rarity.color)
                                            .fontWeight(.bold)
                                            .padding(.bottom)
                                    }
                                    .padding()
                                }
                                .padding(.horizontal)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .strokeBorder(item.rarity.color.opacity(0.8), lineWidth: 2)
                                )
                            }
                        } else if pullCount > 1 {
                            // Multiple items display
                            Text("Erhaltene Items:")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(multipleItems) { item in
                                    ShopItemView(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            showUnlockAlert = true
                        }) {
                            Text("Ziehen beenden")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(pullButtonColor)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer(minLength: 30)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("HomeScreenDungeon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 2)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarBackButtonHidden(true)
        }
        .overlay {
            if showUnlockAlert {
                UnlockItemsAlert(
                    isPresented: $showUnlockAlert,
                    onContinue: {
                        // Items automatically unlocked
                        dismiss()
                    }
                )
            }
        }
    }
    
    private func performPull() {
        if canAfford() {
            deductCurrency()
            
            if pullCount == 1 {
                currentItem = itemGenerator.generateRandomItem()
            } else {
                multipleItems = itemGenerator.generateMultipleItems(count: pullCount)
            }
            
            isPulled = true
            showingItems = true
        }
    }
    
    private func canAfford() -> Bool {
        if currency == "gems" {
            return currencyManager.gems >= pullCost
        } else {
            return currencyManager.coins >= pullCost
        }
    }
    
    private func deductCurrency() {
        if currency == "gems" {
            currencyManager.gems -= pullCost
        } else {
            currencyManager.coins -= pullCost
        }
    }
}

// View Extensions
extension View {
    func glow(color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 2)
            .shadow(color: color, radius: radius / 2)
    }
}

// Preview
#Preview {
    NavigationView {
        ShopOpeningView(
            pullCount: 1,
            currency: "gems",
            currencyManager: GameCurrency.shared
        )
    }
}

#Preview {
    NavigationView {
        ShopOpeningView(
            pullCount: 10,
            currency: "gems",
            currencyManager: GameCurrency.shared
        )
    }
}
