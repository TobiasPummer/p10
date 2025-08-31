import SwiftUI

struct InventoryView: View {
    @Binding var showInventory: Bool
    var items: [Item]
    var skills: [Skill]
    var showItems: Bool
    var clickedSkill: Int
    @State private var selectedItem: Item? = nil
    @State private var selectedSkill: Skill? = nil
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
        BackgroundView()
            .overlay {
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button {
                            showInventory.toggle()
                        } label: {
                            Image("Regular_01")
                        }
                        .padding(.trailing, 40)
                    }
                    .padding(.top, 45)
                    
                    Spacer()
                }
                ScrollView(showsIndicators: false) {
                    VStack {
                        if showItems {
                            ForEach(items) { item in
                                Text(item.id)
                                    .font(Font.custom("Enchanted Land", size: 24))
                                    .onTapGesture {
                                        updateSelectedItem(item)
                                        showInventory.toggle()
                                    }
                                    .onLongPressGesture {
                                        selectedItem = item
                                    }
                                    .sheet(item: $selectedItem) { selectedItem in
                                        ItemInfoView(item: selectedItem)
                                    }
                            }
                        } else {
                            ForEach(skills) { skill in
                                Text(skill.id)
                                    .font(Font.custom("Enchanted Land", size: 24))
                                    .onTapGesture {
                                        updateSelectedSkill(skill)
                                        showInventory.toggle()
                                    }
                                    .onLongPressGesture {
                                        selectedSkill = skill
                                    }
                                    .sheet(item: $selectedSkill) { selectedSkill in
                                        SkillInfoView(skill: selectedSkill)
                                    }
                            }
                        }
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                }
            }
    }
    
    func updateSelectedItem(_ item: Item) {
        switch item.equipmentClass.ID {
        case 1:
            selectedWeapon = item.id
        case 2:
            selectedHelmet = item.id
        case 3:
            selectedChestplate = item.id
        case 4:
            selectedBoots = item.id
        case 5:
            selectedRing = item.id
        case 6:
            selectedAmulett = item.id
        default:
            print("Unknown equipment class")
        }
    }
    
    func updateSelectedSkill(_ skill: Skill) {
        switch clickedSkill {
        case 1:
            skill1 = skill.id
        case 2:
            skill2 = skill.id
        case 3:
            skill3 = skill.id
        case 4:
            skill4 = skill.id
        case 5:
            skill5 = skill.id
        case 6:
            skill6 = skill.id
        default:
            print("Unknown equipment class")
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                Image("00_Banner_Vertical")
                    .resizable()
                Image("01_Banner_Vertical")
                    .resizable()
                Image("01_Banner_Vertical")
                    .resizable()
                Image("01_Banner_Vertical")
                    .resizable()
                Image("01_Banner_Vertical")
                    .resizable()
                Image("01_Banner_Vertical")
                    .resizable()
                Image("01_Banner_Vertical")
                    .resizable()
                Image("02_Banner_Vertical")
                    .resizable()
            }
            
            ForEach(0..<9, id:\.self) { _ in
                GridRow {
                    Image("03_Banner_Vertical")
                        .resizable()
                    Image("04_Banner_Vertical")
                        .resizable()
                    Image("04_Banner_Vertical")
                        .resizable()
                    Image("04_Banner_Vertical")
                        .resizable()
                    Image("04_Banner_Vertical")
                        .resizable()
                    Image("04_Banner_Vertical")
                        .resizable()
                    Image("04_Banner_Vertical")
                        .resizable()
                    Image("05_Banner_Vertical")
                        .resizable()
                }
            }
            
            GridRow {
                Image("06_Banner_Vertical")
                    .resizable()
                Image("07_Banner_Vertical")
                    .resizable()
                Image("07_Banner_Vertical")
                    .resizable()
                Image("07_Banner_Vertical")
                    .resizable()
                Image("07_Banner_Vertical")
                    .resizable()
                Image("07_Banner_Vertical")
                    .resizable()
                Image("07_Banner_Vertical")
                    .resizable()
                Image("08_Banner_Vertical")
                    .resizable()
            }
        }
    }
}

#Preview {
    InventoryView(showInventory: .constant(false), items: [Item(id: "Helmet", description: "Suck cock", equipmentClass: EquipmentClass(ID: 2, BenefittingStat: "Willpower"), rarity: 2, statBonus: 2)], skills: [], showItems: true, clickedSkill: 6)
}
