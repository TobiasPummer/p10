//
//  EnemyStruct.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 17.09.24.
//

import Foundation

struct Enemy {
    var id: String
    var health: Int
    var strength: Int
    var resistance: Int
    var dexterity: Int
    var intelligence: Int
    var willpower: Int
    var luck: Int
    var typeID: Int
    var skills: [Skill]
    var dropItems: [Item]
    
    init(id: String, health: Int, strength: Int, resistance: Int, dexterity: Int, intelligence: Int, willpower: Int, luck: Int, typeID: Int, skills: [Skill], dropItems: [Item]) {
        self.id = id
        self.health = health
        self.strength = strength
        self.resistance = resistance
        self.dexterity = dexterity
        self.intelligence = intelligence
        self.willpower = willpower
        self.luck = luck
        self.typeID = typeID
        self.skills = skills
        self.dropItems = dropItems
    }
}
