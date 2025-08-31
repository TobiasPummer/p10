//
//  DungeonView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 10.09.24.
//

import SwiftUI

struct DungeonView: View {
    @State var enemy: Enemy
    @State var wave: Int = 1
    @State var character: Character
    @State var health: Int
    @State var enemyHealth: Int
    @State var isAttacking: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            Text("Wave \(wave)")
                .foregroundStyle(.white)
                .font(Font.custom("Enchanted Land", size: 24))
            
            HStack {
                PixelAnimationView(imageNames: CharacterImages.goblin.imageNames, fps: 10)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .overlay {
                        VStack {
                            HealthBarView(health: $enemyHealth, startHealth: enemy.health, height: 30)
                                .padding(.bottom, 150)
                        }
                    }
            }
            
            PixelAnimationView(imageNames: CharacterImages.warrior.imageNames, fps: 10)
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
            Grid {
                HealthBarView(health: $health, startHealth: character.health, height: 40)
                
                GridRow {
                    AttackView(skill: character.skills[0])
                        .onTapGesture {
                            attack(character.skills[0])
                            isAttacking = true
                        }
                        .disabled(isAttacking)
                    
                    AttackView(skill: character.skills[1])
                        .onTapGesture {
                            attack(character.skills[1])
                            isAttacking = true
                        }
                        .disabled(isAttacking)
                    
                    AttackView(skill: character.skills[2])
                        .onTapGesture {
                            attack(character.skills[2])
                            isAttacking = true
                        }
                        .disabled(isAttacking)
                }
                GridRow {
                    AttackView(skill: character.skills[3])
                        .onTapGesture {
                            attack(character.skills[3])
                            isAttacking = true
                        }
                        .disabled(isAttacking)
                    
                    AttackView(skill: character.skills[4])
                        .onTapGesture {
                            attack(character.skills[4])
                            isAttacking = true
                        }
                        .disabled(isAttacking)
                    
                    AttackView(skill: character.skills[5])
                        .onTapGesture {
                            attack(character.skills[5])
                            isAttacking = true
                        }
                        .disabled(isAttacking)
                }
            }
            Spacer()
        }
        .padding()
        .background(Image("dungeonBackground").resizable().scaledToFill())
        .ignoresSafeArea()
        .onChange(of: health) {
            if health <= 0 {
                withAnimation {
                    dismiss()
                }
            }
        }
        .onChange(of: enemyHealth) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                if enemyHealth <= 0 {
                    if wave < 3 {
                        withAnimation {
                            enemyHealth = enemy.health
                            wave += 1
                        }
                    } else {
                        withAnimation {
                            dismiss()
                        }
                    }
                }
                
                isAttacking = false
            })
        }
    }
    
    func attack(_ skill: Skill) {
        withAnimation {
            let damage = (character.strength * skill.Power) / 100 - enemy.resistance
            
            if damage >= 1 {
                let health = enemyHealth - damage
                
                if health <= 0 {
                    enemyHealth = 0
                } else {
                    enemyHealth = health
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            withAnimation {
                let damage = (enemy.strength * enemy.skills[0].Power) / 100 - character.resistance
                
                if damage >= 1 {
                    let characterHealth = health - damage
                    
                    if characterHealth <= 0 {
                        health = 0
                    } else {
                        health = characterHealth
                    }
                } else {
                    let characterHealth = self.health - 1
                    
                    if characterHealth <= 0 {
                        health = 0
                    } else {
                        health = characterHealth
                    }
                }
            }
        })
    }
}

struct AttackView: View {
    var skill: Skill
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
            .foregroundStyle(Color.black)
            .opacity(0.6)
            .frame(maxHeight: 60)
            .overlay {
                Text(skill.id)
                    .foregroundStyle(Color.white)
                    .font(Font.custom("Enchanted Land", size: 24))
            }
    }
}

