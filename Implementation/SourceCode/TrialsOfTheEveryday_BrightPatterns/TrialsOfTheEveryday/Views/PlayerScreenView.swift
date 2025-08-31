//
//  PlayerScreenView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 09.09.24.
//

import SwiftUI

struct PlayerScreenView: View {
    @State var showItems: Bool = true
    @State var showInventory: Bool = false
    @State var itemsToShow: [Item] = []
    @State var clickedSkill: Int = 0
    var helmets: [Item]
    var chestplates: [Item]
    var boots: [Item]
    var weapons: [Item]
    var rings: [Item]
    var amuletts: [Item]
    var skills: [Skill]
    
    @State private var selectedItem: Item? = nil
    @State private var selectedSkill: Skill? = nil
    
    @AppStorage("class") private var characterClass: String = ""
    @AppStorage("health") private var health: Int = 0
    @AppStorage("strength") private var strength: Int = 0
    @AppStorage("resistance") private var resistance: Int = 0
    @AppStorage("dexterity") private var dexterity: Int = 0
    @AppStorage("intelligence") private var intelligence: Int = 0
    @AppStorage("willpower") private var willpower: Int = 0
    @AppStorage("statpoints") private var statpoints: Int = 0
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
        ZStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            showItems.toggle()
                        }
                    } label: {
                        Image(showItems ? "Button_Blue_3Slides_Pressed":"Button_Blue_3Slides").overlay {
                            Text("Items")
                                .padding(.bottom, showItems ? 5:10)
                                .font(Font.custom("Enchanted Land", size: 36))
                        }
                    }
                    .disabled(showItems)
                    .foregroundStyle(.black)
                    
                    Button {
                        withAnimation {
                            showItems.toggle()
                        }
                    } label: {
                        Image(!showItems ? "Button_Blue_3Slides_Pressed":"Button_Blue_3Slides").overlay {
                            Text("Skills")
                                .padding(.bottom, !showItems ? 5:10)
                                .font(Font.custom("Enchanted Land", size: 36))
                        }
                    }
                    .disabled(!showItems)
                    .foregroundStyle(.black)
                }
                
                Spacer()
                
                HStack {
                    VStack {
                        if showItems {
                            ItemView(showInventory: $showInventory, image: "Inventory_Slot_4", items: helmets.filter {$0.id == selectedHelmet})
                                .onTapGesture {
                                    itemsToShow = helmets.filter {$0.id != selectedHelmet}
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedItem = helmets.filter {$0.id == selectedHelmet}[0]
                                }
                                .sheet(item: $selectedItem) { selectedItem in
                                    ItemInfoView(item: selectedItem)
                                }
                            ItemView(showInventory: $showInventory, image: "Inventory_Slot_5", items: chestplates.filter {$0.id == selectedChestplate})
                                .onTapGesture {
                                    itemsToShow = chestplates.filter {$0.id != selectedChestplate}
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedItem = chestplates.filter {$0.id == selectedChestplate}[0]
                                }
                                .sheet(item: $selectedItem) { selectedItem in
                                    ItemInfoView(item: selectedItem)
                                }
                            ItemView(showInventory: $showInventory, image: "Inventory_Slot_8", items: boots.filter {$0.id == selectedBoots})
                                .onTapGesture {
                                    itemsToShow = boots.filter {$0.id != selectedBoots}
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedItem = boots.filter {$0.id == selectedBoots}[0]
                                }
                                .sheet(item: $selectedItem) { selectedItem in
                                    ItemInfoView(item: selectedItem)
                                }
                        } else {
                            SkillView(showInventory: $showInventory, skills: skills.filter {$0.id == skill1})
                                .onTapGesture {
                                    clickedSkill = 1
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedSkill = skills.filter {$0.id == skill1}[0]
                                }
                                .sheet(item: $selectedSkill) { selectedSkill in
                                    SkillInfoView(skill: selectedSkill)
                                }
                            
                            SkillView(showInventory: $showInventory, skills: skills.filter {$0.id == skill2})
                                .onTapGesture {
                                    clickedSkill = 2
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedSkill = skills.filter {$0.id == skill2}[0]
                                }
                                .sheet(item: $selectedSkill) { selectedSkill in
                                    SkillInfoView(skill: selectedSkill)
                                }
                            
                            SkillView(showInventory: $showInventory, skills: skills.filter {$0.id == skill3})
                                .onTapGesture {
                                    clickedSkill = 3
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedSkill = skills.filter {$0.id == skill3}[0]
                                }
                                .sheet(item: $selectedSkill) { selectedSkill in
                                    SkillInfoView(skill: selectedSkill)
                                }
                        }
                    }
                    
                    
                    PixelAnimationView(imageNames: CharacterImages.warrior.imageNames, fps: 10)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                    
                    VStack {
                        if showItems {
                            ItemView(showInventory: $showInventory, image: "Inventory_Slot_2", items: weapons.filter {$0.id == selectedWeapon})
                                .onTapGesture {
                                    itemsToShow = weapons.filter {$0.id != selectedWeapon}
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedItem = weapons.filter {$0.id == selectedWeapon}[0]
                                }
                                .sheet(item: $selectedItem) { selectedItem in
                                    ItemInfoView(item: selectedItem)
                                }

                            ItemView(showInventory: $showInventory, image: "Inventory_Slot_9", items: rings.filter {$0.id == selectedRing})
                                .onTapGesture {
                                    itemsToShow = rings.filter {$0.id != selectedRing}
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedItem = rings.filter {$0.id == selectedRing}[0]
                                }
                                .sheet(item: $selectedItem) { selectedItem in
                                    ItemInfoView(item: selectedItem)
                                }
                            ItemView(showInventory: $showInventory, image: "Inventory_Slot_10", items: amuletts.filter {$0.id == selectedAmulett})
                                .onTapGesture {
                                    itemsToShow = amuletts.filter {$0.id != selectedAmulett}
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedItem = amuletts.filter {$0.id == selectedAmulett}[0]
                                }
                                .sheet(item: $selectedItem) { selectedItem in
                                    ItemInfoView(item: selectedItem)
                                }
                        } else {
                            SkillView(showInventory: $showInventory, skills: skills.filter {$0.id == skill4})
                                .onTapGesture {
                                    clickedSkill = 4
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }.onLongPressGesture {
                                    selectedSkill = skills.filter {$0.id == skill4}[0]
                                }
                                .sheet(item: $selectedSkill) { selectedSkill in
                                    SkillInfoView(skill: selectedSkill)
                                }
                            
                            SkillView(showInventory: $showInventory, skills: skills.filter {$0.id == skill5})
                                .onTapGesture {
                                    clickedSkill = 5
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedSkill = skills.filter {$0.id == skill5}[0]
                                }
                                .sheet(item: $selectedSkill) { selectedSkill in
                                    SkillInfoView(skill: selectedSkill)
                                }
                            
                            SkillView(showInventory: $showInventory, skills: skills.filter {$0.id == skill6})
                                .onTapGesture {
                                    clickedSkill = 6
                                    withAnimation {
                                        showInventory.toggle()
                                    }
                                }
                                .onLongPressGesture {
                                    selectedSkill = skills.filter {$0.id == skill6}[0]
                                }
                                .sheet(item: $selectedSkill) { selectedSkill in
                                    SkillInfoView(skill: selectedSkill)
                                }
                        }
                    }
                }
                
                
                Spacer()
                
                Text("Available Points: \(statpoints)")
                    .foregroundStyle(Color.white)
                    .font(Font.custom("Enchanted Land", size: 24))
                
                Spacer()
                
                Grid {
                    GridRow {
                        StatView(text: "Health", value: health)
                        StatView(text: "Strength", value: strength)
                        StatView(text: "Resistance", value: resistance)
                    }
                    GridRow {
                        StatView(text: "Dexterity", value: dexterity)
                        StatView(text: "Intelligence", value: intelligence)
                        StatView(text: "Willpower", value: willpower)
                    }
                }
                .foregroundStyle(Color.white)
            }
            .disabled(showInventory)
            
            if showInventory {
                InventoryView(showInventory: $showInventory, items: itemsToShow, skills: skills.filter {$0.id != skill1 && $0.id != skill2 && $0.id != skill3 && $0.id != skill4 && $0.id != skill5 && $0.id != skill6}, showItems: showItems, clickedSkill: clickedSkill)
            }
        }
    }
}


#Preview {
    PlayerScreenView(helmets: [], chestplates: [], boots: [], weapons: [], rings: [], amuletts: [], skills: [])
}

struct StatView: View {
    var text: String
    var value: Int
    
    var body: some View {
        VStack {
            Text(text)
                .font(Font.custom("Enchanted Land", size: 24))
            Text("\(value)")
                .font(Font.custom("Enchanted Land", size: 24))
        }
    }
}

struct ItemView: View {
    @Binding var showInventory: Bool
    var image: String
    var items: [Item]
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .overlay {
                Text(items.first?.id ?? "nothing")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 55)
                    .font(Font.custom("Enchanted Land", size: 24))
            }
    }
}

struct SkillView: View {
    @Binding var showInventory: Bool
    var skills: [Skill]
    
    var body: some View {
        Image("Inventory_Slot_1")
            .resizable()
            .scaledToFit()
            .overlay {
                Text(skills.first?.id ?? "nothing")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 55)
                    .font(Font.custom("Enchanted Land", size: 24))
            }
    }
}
