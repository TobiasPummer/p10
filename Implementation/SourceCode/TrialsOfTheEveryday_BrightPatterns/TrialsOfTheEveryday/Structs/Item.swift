//
//  EnemyStruct.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 17.09.24.
//

import Foundation

struct Item: Identifiable {
    var id: String
    var description: String
    var equipmentClass: EquipmentClass // Wird der Name des referenzierten Dokuments sein
    var rarity: Int        // Wird der Name des referenzierten Dokuments sein
    var statBonus: Int
    
    init(id: String, description: String, equipmentClass: EquipmentClass, rarity: Int, statBonus: Int) {
        self.id = id
        self.description = description
        self.equipmentClass = equipmentClass
        self.rarity = rarity
        self.statBonus = statBonus
    }
    
    init() {
        id = ""
        description = ""
        equipmentClass = EquipmentClass(ID: 0, BenefittingStat: "")
        rarity = 0
        statBonus = 0
    }
}
