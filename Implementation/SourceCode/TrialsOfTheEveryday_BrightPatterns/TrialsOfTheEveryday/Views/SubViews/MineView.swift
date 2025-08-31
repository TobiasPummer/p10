//
//  MineView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 17.09.24.
//

import SwiftUI

struct MineView: View {
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                Image("00_GoldMine_Inactive")
                    .resizable()
                    .scaledToFit()
                Image("01_GoldMine_Inactive")
                    .resizable()
                    .scaledToFit()
                Image("02_GoldMine_Inactive")
                    .resizable()
                    .scaledToFit()
            }
            
            GridRow {
                Image("03_GoldMine_Inactive")
                    .resizable()
                    .scaledToFit()
                Image("04_GoldMine_Inactive")
                    .resizable()
                    .scaledToFit()
                Image("05_GoldMine_Inactive")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    MineView()
}
