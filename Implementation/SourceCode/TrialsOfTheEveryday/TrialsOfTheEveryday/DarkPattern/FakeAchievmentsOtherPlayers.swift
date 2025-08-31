
import SwiftUI

struct FakeAchievmentsOtherPlayers: View {
    @State private var currentAchievement: FakeAchievement
    @State private var showBanner = true
    
    private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    init() {
        _currentAchievement = State(initialValue: FakeAchievement.generateRandom())
    }
    
    var body: some View {
        if showBanner {
            VStack {
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
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.4))
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
              Spacer()
            }
            .onReceive(timer) { _ in
                withAnimation(.easeInOut) {
                    currentAchievement = FakeAchievement.generateRandom()
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
        }
    }
}

// Model for fake player achievements
struct FakeAchievement {
    let playerName: String
    let description: String
    
    static func generateRandom() -> FakeAchievement {
        let playerNames = [
            "Drachenjäger99", "EinhornFan88", "GameMaster42", "PixelHeld", "MagicQueen",
            "LegendSlayer", "EpicGamer23", "SkilledWarrior", "DungeonMaster", "QuestHunter",
            "ShadowNinja", "GoldCollector", "MysteryHero", "LootLegend", "BattleWizard"
        ]
        
        let rarities = ["gewöhnlichen", "seltenen", "epischen", "legendären"]
        let achievements = [
            "hat einen \(rarities.randomElement()!) Skill gezogen!",
            "hat \(Int.random(in: 2...5))x \(rarities.randomElement()!) Skills erhalten!",
            "hat ein \(rarities.randomElement()!) Item gefunden!",
            "hat Level \(Int.random(in: 10...100)) erreicht!",
            "hat eine Quest mit \(Int.random(in: 2...5)) Sternen abgeschlossen!",
            "hat einen Bosskampf gewonnen!",
            "hat \(Int.random(in: 500...10000)) Münzen gesammelt!",
            "hat ein neues Gebiet freigeschaltet!",
            "ist einer Gilde beigetreten!",
            "hat \(Int.random(in: 3...20)) Gegner besiegt!"
        ]
        
        return FakeAchievement(
            playerName: playerNames.randomElement() ?? "Player1",
            description: "\(playerNames.randomElement() ?? "Player1") \(achievements.randomElement() ?? "hat gewonnen!")"
        )
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3) // Background to see the banner clearly
            .ignoresSafeArea()
        
        FakeAchievmentsOtherPlayers()
    }
}
