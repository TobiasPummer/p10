

import SwiftUI

struct DropRatesView: View {
    var isLimitedOffer: Bool = false
    
    // Default values for normal drop rates
    var normalLegendaryChance: String = "0.5%"
    var normalEpicChance: String = "4.95%"
    var normalRareChance: String = "19.5%"
    var normalCommonChance: String = "75%"
    
    // Default values for limited offer drop rates
    var limitedLegendaryChance: String = "1.1%"
    var limitedEpicChance: String = "10%"
    var limitedRareChance: String = "28.9%"
    var limitedCommonChance: String = "60%"
    
    // Legendary skills to display
    var legendarySkills: [(name: String, description: String)] = [
        ("Feuersturm", "Verursacht Flächenschaden an allen Gegnern"),
        ("Heiliger Schild", "Reduziert den erlittenen Schaden um 25%"),
        ("Zeitschleife", "Setzt alle Fähigkeiten zurück"),
        ("Sturmklinge", "Erhöht Angriffsgeschwindigkeit um 40%")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        Text("Genaue Dropchancen")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                            .padding(.bottom, 8)
                        
                        if isLimitedOffer {
                            Text("Während dieser Aktion:")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            makeDropRateRow(rarity: "Legendär", chance: limitedLegendaryChance, normalChance: normalLegendaryChance, color: .purple)
                            makeDropRateRow(rarity: "Episch", chance: limitedEpicChance, normalChance: normalEpicChance, color: .blue)
                            makeDropRateRow(rarity: "Selten", chance: limitedRareChance, normalChance: normalRareChance, color: .green)
                            makeDropRateRow(rarity: "Gewöhnlich", chance: limitedCommonChance, normalChance: normalCommonChance, color: .gray)
                        } else {
                            Text("Standardchancen:")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            makeDropRateRow(rarity: "Legendär", chance: normalLegendaryChance, normalChance: "", color: .purple)
                            makeDropRateRow(rarity: "Episch", chance: normalEpicChance, normalChance: "", color: .blue)
                            makeDropRateRow(rarity: "Selten", chance: normalRareChance, normalChance: "", color: .green)
                            makeDropRateRow(rarity: "Gewöhnlich", chance: normalCommonChance, normalChance: "", color: .gray)
                        }
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("Verfügbare legendäre Skills:")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(legendarySkills, id: \.name) { skill in
                                makeSkillRow(name: skill.name, description: skill.description)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    
                    Text("Hinweis: Jeder Skill innerhalb einer Seltenheitsstufe hat die gleiche Wahrscheinlichkeit, gezogen zu werden.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Dropchancen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func makeDropRateRow(rarity: String, chance: String, normalChance: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(rarity)
                .font(.body)
            
            Spacer()
            
            Text(chance)
                .font(.body.bold())
            
            if !normalChance.isEmpty {
                Text("(normal: \(normalChance))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func makeSkillRow(name: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 10, height: 10)
                
                Text(name)
                    .font(.body.bold())
            }
            
            Text(description)
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.leading, 20)
        }
    }
}

#Preview {
    // Preview with limited offer rates
    DropRatesView(isLimitedOffer: true)
}

