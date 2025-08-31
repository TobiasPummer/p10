//
//  ClassPickerView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 10.09.24.
//

import SwiftUI

struct ClassPickerView: View {
    var body: some View {
        VStack {
            Text("Choose your class")
                .font(.largeTitle)
            
            Spacer(minLength: 20)
            
            Grid {
                GridRow {
                    CharacterView(name: "Knight", available: true)
                    CharacterView(name: "Mage", available: false)
                }
                
                GridRow {
                    CharacterView(name: "Assassin", available: false)
                    CharacterView(name: "Barbarian", available: false)
                }
                
                GridRow {
                    CharacterView(name: "Rogue", available: false)
                    CharacterView(name: "Healer", available: false)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ClassPickerView()
}

struct CharacterView: View {
    var name: String
    var available: Bool
    
    @AppStorage("class") private var characterClass: String = ""
    @AppStorage("health") private var health: Int = 0
    @AppStorage("strength") private var strength: Int = 0
    @AppStorage("resistance") private var resistance: Int = 0
    @AppStorage("dexterity") private var dexterity: Int = 0
    @AppStorage("intelligence") private var intelligence: Int = 0
    @AppStorage("willpower") private var willpower: Int = 0
    @AppStorage("firstLaunch") private var firstLaunch: Bool = true
    @AppStorage("selectedHelmet") private var selectedHelmet: String = ""
    @AppStorage("selectedChestplate") private var selectedChestplate: String = ""
    @AppStorage("selectedBoots") private var selectedBoots: String = ""
    @AppStorage("selectedWeapon") private var selectedWeapon: String = ""
    @AppStorage("selectedRing") private var selectedRing: String = ""
    @AppStorage("selectedAmulett") private var selectedAmulett: String = ""
    @AppStorage("skill1") private var skill1: String = ""
    @AppStorage("skill2") private var skill2: String = ""
    @AppStorage("skill3") private var skill3: String = ""
    @AppStorage("skill4") private var skill4: String = ""
    @AppStorage("skill5") private var skill5: String = ""
    @AppStorage("skill6") private var skill6: String = ""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .disabled(!available)
            .foregroundStyle(.cyan)
            .overlay {
                VStack {
                    Text(name)
                        .foregroundStyle(.white)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                    PixelAnimationView(imageNames: CharacterImages.warrior.imageNames, fps: 10)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
                .padding()
                .onTapGesture {
                    if available {
                        if name == "Knight" {
                            asignValues(characterClass: "Knight", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                        } else if name == "Mage" {
                            asignValues(characterClass: "Mage", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                        } else if name == "Assassin" {
                            asignValues(characterClass: "Assassin", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                        } else if name == "Barbarian" {
                            asignValues(characterClass: "Barbarian", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                        } else if name == "Rogue" {
                            asignValues(characterClass: "Rogue", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                        } else if name == "Healer" {
                            asignValues(characterClass: "Healer", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                        }
                        
                        selectedHelmet = "TraineesHelmet"
                        selectedChestplate = "TraineesChestplate"
                        selectedBoots = "TraineesBoots"
                        selectedWeapon = "TraineesShortsword"
                        selectedRing = "OldFamilyRing"
                        selectedAmulett = "AzureAmulett"
                        skill1 = "Cleave"
                        skill2 = "CrushingBlow"
                        skill3 = "HorizontalSlash"
                        skill4 = "PiercingThrust"
                        skill5 = "ShieldBash"
                        skill6 = "UpwardStrike"
                        
                        withAnimation {
                            firstLaunch.toggle()
                        }
                    }

                }
            }
            .overlay {
                if !available {
                    Color.gray
                        .opacity(0.75)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .onTapGesture {
                if available {
                    if name == "Knight" {
                        asignValues(characterClass: "Knight", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                    } else if name == "Mage" {
                        asignValues(characterClass: "Mage", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                    } else if name == "Assassin" {
                        asignValues(characterClass: "Assassin", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                    } else if name == "Barbarian" {
                        asignValues(characterClass: "Barbarian", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                    } else if name == "Rogue" {
                        asignValues(characterClass: "Rogue", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                    } else if name == "Healer" {
                        asignValues(characterClass: "Healer", health: 10, strength: 10, resistance: 10, dexterity: 10, intelligence: 10, willpower: 10)
                    }
                    
                    selectedHelmet = "TraineesHelmet"
                    selectedChestplate = "TraineesChestplate"
                    selectedBoots = "TraineesBoots"
                    selectedWeapon = "TraineesShortsword"
                    selectedRing = "OldFamilyRing"
                    selectedAmulett = "AzureAmulett"
                    skill1 = "Cleave"
                    skill2 = "CrushingBlow"
                    skill3 = "HorizontalSlash"
                    skill4 = "PiercingThrust"
                    skill5 = "ShieldBash"
                    skill6 = "UpwardStrike"
                    
                    withAnimation {
                        firstLaunch.toggle()
                    }
                }
            }
    }
    
    func asignValues(characterClass: String, health: Int, strength: Int, resistance: Int, dexterity: Int, intelligence: Int, willpower: Int) {
        
        self.characterClass = characterClass
        self.health = health
        self.strength = strength
        self.resistance = resistance
        self.dexterity = dexterity
        self.intelligence = intelligence
        self.willpower = willpower
    }
}
