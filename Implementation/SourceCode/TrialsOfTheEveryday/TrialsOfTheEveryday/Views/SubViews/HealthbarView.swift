//
//  HealthbarView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 17.09.24.
//

import SwiftUI

struct HealthBarView: View {
    @Binding var health: Int
    var startHealth: Int
    var height: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: width-10, height: height-10)
                        .foregroundStyle(Color.black)
                        .opacity(0.7)
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(health > (startHealth/4) ? Color.green : Color.red, lineWidth: 4)
                        .frame(width: width-10, height: height-10)
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: min(CGFloat(health) / CGFloat(startHealth) * (width - 10), width - 10), height: height-10)
                        .foregroundStyle(health > (startHealth/4) ? Color.green : Color.red)
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                    
                    Text("\(health)/\(startHealth)")
                        .contentTransition(.numericText())
                        .frame(height: height-10)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.white)
                        .font(Font.custom("Enchanted Land", size: height/2))
                        .padding(.leading, 10)
                        .padding(.top, 5)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.gray)
                            .frame(width: width, height: height)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: width-10, height: height-10)
                            .padding(.horizontal, 5)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                }
                .frame(height: height)
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal, 25)
        }
    }
}


#Preview {
    HealthBarView(health: .constant(500), startHealth: 300, height: 40)
}
