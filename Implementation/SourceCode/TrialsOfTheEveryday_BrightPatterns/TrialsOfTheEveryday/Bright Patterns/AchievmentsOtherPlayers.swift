
import SwiftUI
struct PlayerFeedBanner: View {
    @AppStorage("showPlayerFeed") private var showPlayerFeed = true
    @State private var currentAchievement: PlayerAchievement
    @State private var showBanner = true
    @State private var showTransparencyInfo = false
    
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    init() {
        _currentAchievement = State(initialValue: PlayerAchievement.generateRandom())
    }
    
    var body: some View {
        if showPlayerFeed && showBanner {
            VStack(spacing: 0) {
                // Banner header
                Text("Simulierter Feed (Demo) aktiviert")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // Main banner content
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(red: Double.random(in: 0.3...0.8),
                                  green: Double.random(in: 0.3...0.8),
                                  blue: Double.random(in: 0.3...0.8)))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(currentAchievement.playerName.prefix(1)))
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                        )
                    
                    Text(currentAchievement.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button {
                            showTransparencyInfo.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14))
                                .padding(5)
                        }
                        
                        Button {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showBanner = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14, weight: .bold))
                                .padding(5)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.4))
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal, 16)
                
                // Transparency info
                if showTransparencyInfo {
                    Text("Dieser Feed basiert auf echten oder simulierten Erfolgen. Du kannst ihn in den Einstellungen deaktivieren.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                        .transition(.opacity)
                }
            }
            .padding(.top, 50) // Add spacing at the top
            .frame(maxWidth: .infinity, alignment: .top)
            .onReceive(timer) { _ in
                withAnimation(.easeInOut) {
                    currentAchievement = PlayerAchievement.generateRandom()
                }
                
                // Reset banner if hidden
                if !showBanner {
                    showBanner = true
                }
            }
            .onAppear {
                // Auto-hide after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeOut) {
                        showBanner = false
                    }
                }
            }
            .transition(.move(edge: .top).combined(with: .opacity))
            .zIndex(100)
        }
    }
}

// Model for player achievements
struct PlayerAchievement {
    let playerName: String
    let description: String
    
    static func generateRandom() -> PlayerAchievement {
        let playerNames = [
            "Drachenjäger99", "EinhornFan88", "GameMaster42", "PixelHeld", "MagicQueen",
            "LegendSlayer", "EpicGamer23", "SkilledWarrior", "DungeonMaster", "QuestHunter",
            "ShadowNinja", "GoldCollector", "MysteryHero", "LootLegend", "BattleWizard",
            "MiraTheMage"
        ]
        
        let rarities = ["gewöhnlichen", "seltenen", "epischen", "legendären"]
        let items = ["Schwert", "Amulett", "Rune", "Schild", "Helm", "Rüstung", "Stab", "Ring", "Klinge"]
        
        let achievementTypes = [
            "Demo: \(playerNames.randomElement() ?? "Spieler") könnte [\(rarities.randomElement() ?? "seltene") \(items.randomElement() ?? "Item")] ziehen",
            "Demo: \(playerNames.randomElement() ?? "Spieler") hat vielleicht \(Int.random(in: 2...5))x \(rarities.randomElement() ?? "seltene") Skills erhalten",
            "Demo: \(playerNames.randomElement() ?? "Spieler") könnte Level \(Int.random(in: 10...100)) erreichen",
            "Demo: \(playerNames.randomElement() ?? "Spieler") hat möglicherweise eine Quest abgeschlossen"
        ]
        
        // Sometimes show "Live" achievements to mix with demo ones (20% chance)
        let isLive = Double.random(in: 0...1) < 0.2
        
        if isLive {
            return PlayerAchievement(
                playerName: playerNames.randomElement() ?? "Player1",
                description: "\(playerNames.randomElement() ?? "Player1") hat [\(rarities.randomElement() ?? "Legendäre") \(items.randomElement() ?? "Klinge")] erhalten (Live)"
            )
        } else {
            return PlayerAchievement(
                playerName: playerNames.randomElement() ?? "Player1",
                description: achievementTypes.randomElement() ?? "Demo: Spieler hat etwas erreicht"
            )
        }
    }
}
