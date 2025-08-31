//
//  Character.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 17.09.24.
//

import SwiftUI

struct Character {
    var health: Int
    var strength: Int
    var resistance: Int
    var dexterity: Int
    var intelligence: Int
    var willpower: Int
    var luck: Int
    var skills: [Skill]
    
    init(health: Int, strength: Int, resistance: Int, dexterity: Int, intelligence: Int, willpower: Int, luck: Int, skills: [Skill]) {
        self.health = health
        self.strength = strength
        self.resistance = resistance
        self.dexterity = dexterity
        self.intelligence = intelligence
        self.willpower = willpower
        self.luck = luck
        self.skills = skills
    }
}
