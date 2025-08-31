//
//  SkillInfoView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 23.09.24.
//

import SwiftUI

struct SkillInfoView: View {
    var skill: Skill
    var body: some View {
        VStack {
            Group {
                Text(skill.id)
                Text(skill.description)
                    .multilineTextAlignment(.center)
                Text("Power: \(skill.Power)")
                Text("Offensive Stat " + skill.offCalcStat)
                Text("Defensive Stat: " + skill.defCalcStat)
                Text("Rarity: \(skill.rarity)")
                Text("Type: \(skill.typeID)")
            }
            .font(Font.custom("Enchanted Land", size: 24))
        }
    }
}
