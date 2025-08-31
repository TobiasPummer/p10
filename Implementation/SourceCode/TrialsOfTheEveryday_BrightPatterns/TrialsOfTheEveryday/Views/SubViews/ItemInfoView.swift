//
//  ItemInfoView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 23.09.24.
//
import SwiftUI

struct ItemInfoView: View {
    var item: Item
    var body: some View {
        VStack {
            Group {
                Text(item.id)
                Text(item.description)
                    .multilineTextAlignment(.center)
                Text("Benefitting Stat: " + item.equipmentClass.BenefittingStat)
                Text("Stat Bonus: \(item.statBonus)")
                Text("Rarity: \(item.rarity)")
            }
            .font(Font.custom("Enchanted Land", size: 36))
        }
    }
}
