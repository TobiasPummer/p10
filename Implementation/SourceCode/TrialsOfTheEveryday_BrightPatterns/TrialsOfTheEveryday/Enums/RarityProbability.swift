//
//  RarityProbability.swift
//  TrialsOfTheEveryday
//
//  Created by Tobias Pummer on 12.04.25.
//

import Foundation

// MARK: - Main Rarity Probability Manager
class RarityProbability {
    // MARK: - Rarity Enums
    enum PaidRarity: CaseIterable {
        case common, rare, epic, legendary

        var probability: Double {
            switch self {
            case .common: return 0.6
            case .rare: return 0.289
            case .epic: return 0.1
            case .legendary: return 0.011
            }
        }
    }

    enum FreeRarity: CaseIterable {
        case common, rare, epic, legendary

        var probability: Double {
            switch self {
            case .common: return 0.8
            case .rare: return 0.195
            case .epic: return 0.0495
            case .legendary: return 0.0005
            }
        }
    }
    
    // MARK: - Random Rarity Generation
    static func randomRarity(isPremium: Bool = false) -> Any {
        let rand = Double.random(in: 0...1)
        var cumulative = 0.0

        if isPremium {
            for rarity in PaidRarity.allCases {
                cumulative += rarity.probability
                if rand < cumulative {
                    return rarity
                }
            }
            return PaidRarity.common
        } else {
            for rarity in FreeRarity.allCases {
                cumulative += rarity.probability
                if rand < cumulative {
                    return rarity
                }
            }
            return FreeRarity.common
        }
    }
}
