//
//  CharacterImages.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 09.05.24.
//

import Foundation

enum CharacterImages {
    case warrior
    case warriorAttack
    case goblin
    
    var imageNames: [String] {
        switch self {
        case .warrior:
            return ["00_Warrior_Blue", "01_Warrior_Blue", "02_Warrior_Blue", "03_Warrior_Blue", "04_Warrior_Blue", "05_Warrior_Blue"]
        case .warriorAttack:
            return ["12_Warrior_Blue", "13_Warrior_Blue", "14_Warrior_Blue", "15_Warrior_Blue", "16_Warrior_Blue", "17_Warrior_Blue"]
        case .goblin:
            return ["00_Torch_Red", "01_Torch_Red", "02_Torch_Red", "03_Torch_Red", "04_Torch_Red", "05_Torch_Red", "06_Torch_Red"]
        }
    }
}
