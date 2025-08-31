//
//  RarityProbability.swift
//  TrialsOfTheEveryday
//
//  Created by Tobias Pummer on 12.04.25.
//

import Foundation

enum PaidRarity: CaseIterable {
    case common, rare, epic, legendary

    var probability: Double {
        switch self {
        case .common: return 0.7
        case .rare: return 0.289
        case .epic: return 0.1
        case .legendary: return 0.01
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

func randomRarity() -> PaidRarity {
    let rand = Double.random(in: 0...1)
    var cumulative = 0.0
    for rarity in PaidRarity.allCases {
        cumulative += rarity.probability
        if rand < cumulative {
            return rarity
        }
    }
    return .common
}


