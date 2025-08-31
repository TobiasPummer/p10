//
//  EnemyStruct.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 17.09.24.
//

import Foundation

struct Skill: Identifiable {
    var id: String
    var description: String
    var offCalcStat: String
    var defCalcStat: String
    var Power: Int
    var rarity: Int
    var typeID: Int
    
    init(id: String, description: String, offCalcStat: String, defCalcStat: String, Power: Int, rarity: Int, typeID: Int) {
        self.id = id
        self.description = description
        self.offCalcStat = offCalcStat
        self.defCalcStat = defCalcStat
        self.Power = Power
        self.rarity = rarity
        self.typeID = typeID
    }
    
    init() {
        id = ""
        description = ""
        offCalcStat = ""
        defCalcStat = ""
        Power = 0
        rarity = 0
        typeID = 0
    }
}
