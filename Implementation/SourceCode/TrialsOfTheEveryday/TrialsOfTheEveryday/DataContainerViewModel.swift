//
//  FetchClass.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 21.09.24.
//
import FirebaseFirestore
import SwiftUI

class DataContainerViewModel: ObservableObject {
  @Published var items: [Item] = []
  @Published var helmets: [Item] = []
  @Published var chestplates: [Item] = []
  @Published var boots: [Item] = []
  @Published var weapons: [Item] = []
  @Published var rings: [Item] = []
  @Published var amuletts: [Item] = []
  @Published var skills: [Skill] = []
  @Published var enemies: [Enemy] = []
  
  private var db = Firestore.firestore()
  
  // Abrufen von CharacterItems und den referenzierten Items, sowie Auflösen von Rarity und EquipmentType
  func fetchCharacterItems(completion: @escaping () -> Void) {
    // 1. CharacterItems abrufen
    db.collection("CharacterItems").getDocuments { snapshot, error in
      if let error = error {
        print("Error fetching character items: \(error)")
        completion()
        return
      }
      
      let group = DispatchGroup() // Um auf alle Item-Referenzen zu warten
      var fetchedItems: [Item] = []
      
      snapshot?.documents.forEach { document in
        let data = document.data()
        
        // Wir nehmen an, dass es nur eine Item-Referenz pro CharacterItem gibt
        if let itemReference = data.values.first as? DocumentReference {
          group.enter()
          // 2. Abrufen des referenzierten Item-Dokuments
          itemReference.getDocument { itemSnapshot, error in
            if let error = error {
              print("Error fetching item: \(error)")
              group.leave()
              return
            }
            
            if let itemData = itemSnapshot?.data() {
              let id = itemSnapshot?.documentID ?? "Unknown"
              let description = itemData["Description"] as? String ?? ""
              let statBonus = itemData["StatBonus"] as? Int ?? 0
              
              // Referenzen für rarity und equipmentType abrufen
              if let rarityRef = itemData["Rarity"] as? DocumentReference,
                 let equipmentTypeRef = itemData["EquipmentType"] as? DocumentReference {
                
                // Asynchrone Aufrufe für beide Referenzen
                group.enter()
                rarityRef.getDocument { raritySnapshot, error in
                  let rarity = raritySnapshot?.data()?["Rarity"] as? Int ?? 0
                  group.leave()
                  
                  group.enter()
                  equipmentTypeRef.getDocument { equipmentTypeSnapshot, error in
                    let equipmentID = equipmentTypeSnapshot?.data()?["EquipmentID"] as? Int ?? 0
                    let equipmentType = equipmentTypeSnapshot?.data()?["BenefittingStat"] as? String ?? "Unknown"
                    let equipmentClass = EquipmentClass(ID: equipmentID, BenefittingStat: equipmentType)
                    group.leave()
                    
                    // Füge das Item hinzu, wenn beide Referenzen aufgelöst sind
                    let item = Item(id: id, description: description, equipmentClass: equipmentClass, rarity: rarity, statBonus: statBonus)
                    fetchedItems.append(item)
                  }
                }
              } else {
                // Falls es keine Referenzen gibt
                let item = Item(id: id, description: description, equipmentClass: EquipmentClass(ID: 0, BenefittingStat: "Unknown"), rarity: 0, statBonus: statBonus)
                fetchedItems.append(item)
              }
            }
            group.leave()
          }
        }
      }
      
      // Warten, bis alle Referenzen aufgelöst sind
      group.notify(queue: .main) {
        self.items = fetchedItems
        completion()
      }
    }
  }
  
  func fetchCharacterSkills(completion: @escaping () -> Void) {
    // 1. CharacterSkills abrufen
    db.collection("CharacterSkills").getDocuments { snapshot, error in
      if let error = error {
        print("Error fetching character skills: \(error)")
        completion()
        return
      }
      
      let group = DispatchGroup() // Um auf alle Skill-Referenzen zu warten
      var fetchedSkills: [Skill] = []
      
      snapshot?.documents.forEach { document in
        let data = document.data()
        
        // Wir nehmen an, dass es nur eine Skill-Referenz pro CharacterSkill gibt
        if let skillReference = data.values.first as? DocumentReference {
          group.enter()
          // 2. Abrufen des referenzierten Skill-Dokuments
          skillReference.getDocument { skillSnapshot, error in
            if let error = error {
              print("Error fetching skill: \(error)")
              group.leave()
              return
            }
            
            if let skillData = skillSnapshot?.data() {
              let id = skillSnapshot?.documentID ?? "Unknown"
              let description = skillData["Description"] as? String ?? ""
              let offCalcStat = skillData["OffCalcStat"] as? String ?? ""
              let defCalcStat = skillData["DefCalcStat"] as? String ?? ""
              let power = skillData["Power"] as? Int ?? 0
              
              // Referenzen für Rarity und Type abrufen
              if let rarityRef = skillData["Rarity"] as? DocumentReference,
                 let typeRef = skillData["Type"] as? DocumentReference {
                
                // Asynchrone Aufrufe für beide Referenzen
                group.enter()
                rarityRef.getDocument { raritySnapshot, error in
                  let rarity = raritySnapshot?.data()?["Rarity"] as? Int ?? 0
                  group.leave()
                  
                  group.enter()
                  typeRef.getDocument { typeSnapshot, error in
                    let typeID = typeSnapshot?.data()?["ID"] as? Int ?? 0
                    group.leave()
                    
                    // Füge den Skill hinzu, wenn beide Referenzen aufgelöst sind
                    let skill = Skill(id: id, description: description, offCalcStat: offCalcStat, defCalcStat: defCalcStat, Power: power, rarity: rarity, typeID: typeID)
                    fetchedSkills.append(skill)
                  }
                }
              } else {
                // Falls es keine Referenzen gibt
                let skill = Skill(id: id, description: description, offCalcStat: offCalcStat, defCalcStat: defCalcStat, Power: power, rarity: 0, typeID: 0)
                fetchedSkills.append(skill)
              }
            }
            group.leave()
          }
        }
      }
      
      // Warten, bis alle Referenzen aufgelöst sind
      group.notify(queue: .main) {
        self.skills = fetchedSkills
        completion()
      }
    }
  }
  
  func filterItems() {
    weapons = items.filter { $0.equipmentClass.ID == 1 }
    helmets = items.filter { $0.equipmentClass.ID == 2 }
    chestplates = items.filter { $0.equipmentClass.ID == 3 }
    boots = items.filter { $0.equipmentClass.ID == 4 }
    amuletts = items.filter { $0.equipmentClass.ID == 5 }
    rings = items.filter { $0.equipmentClass.ID == 6 }
  }
  
  func fetchEnemies() {
    enemies.append(Enemy(id: "Goblin",health: 3, strength: 4, resistance: 3, dexterity: 4, intelligence: 1, willpower: 2, luck: 20, typeID: 5, skills: [Skill(id: "PiercingThrust", description: "A focused lunge that pierces an enemy’s armor", offCalcStat: "Strength", defCalcStat: "Resistance", Power: 70, rarity: 2, typeID: 5)], dropItems: [Item(id: "TraineesBoots", description: "Sturdy boots made for the rigors of training. These provide solid footing and modest protection while building a trainee's agility.", equipmentClass: EquipmentClass(ID: 4, BenefittingStat: "Resistance"), rarity: 2, statBonus: 1)]))
    
    /*
     // Enemy-Datenbank abrufen
     db.collection("Enemies").getDocuments { snapshot, error in
     if let error = error {
     print("Error fetching enemies: \(error)")
     completion()
     return
     }
     
     let group = DispatchGroup() // Um auf alle asynchronen Aufrufe zu warten
     var fetchedEnemies: [Enemy] = []
     
     snapshot?.documents.forEach { document in
     let data = document.data()
     let enemyID = document.documentID
     let health = data["Health"] as? Int ?? 0
     let strength = data["Strength"] as? Int ?? 0
     let resistance = data["Resistance"] as? Int ?? 0
     let dexterity = data["Dexterity"] as? Int ?? 0
     let intelligence = data["Intelligence"] as? Int ?? 0
     let willpower = data["Willpower"] as? Int ?? 0
     let luck = data["Luck"] as? Int ?? 0
     
     // Enemy Type referenzieren
     if let typeRef = data["Type"] as? DocumentReference {
     group.enter()
     typeRef.getDocument { typeSnapshot, error in
     let typeID = typeSnapshot?.data()?["ID"] as? Int ?? 0
     
     var enemySkills: [Skill] = []
     var dropItems: [Item] = []
     
     // 1. Skills über Uses-Sammlung referenzieren
     group.enter()
     self.db.collection("Uses").whereField("EnemyID", isEqualTo: document.reference).getDocuments { usesSnapshot, error in
     if let error = error {
     print("Error fetching uses: \(error)")
     group.leave()
     return
     }
     
     usesSnapshot?.documents.forEach { useDoc in
     let useData = useDoc.data()
     if let skillRef = useData["SkillID"] as? DocumentReference {
     group.enter()
     skillRef.getDocument { skillSnapshot, error in
     if let skillData = skillSnapshot?.data() {
     let id = skillSnapshot?.documentID ?? "Unknown"
     let description = skillData["Description"] as? String ?? ""
     let offCalcStat = skillData["OffCalcStat"] as? String ?? ""
     let defCalcStat = skillData["DefCalcStat"] as? String ?? ""
     let power = skillData["Power"] as? Int ?? 0
     
     // Skill-Rarity und Type referenzieren
     if let rarityRef = skillData["Rarity"] as? DocumentReference,
     let typeRef = skillData["Type"] as? DocumentReference {
     
     group.enter()
     rarityRef.getDocument { raritySnapshot, error in
     let rarity = raritySnapshot?.data()?["Rarity"] as? Int ?? 0
     group.leave()
     
     group.enter()
     typeRef.getDocument { typeSnapshot, error in
     let typeID = typeSnapshot?.data()?["ID"] as? Int ?? 0
     let skill = Skill(id: id, description: description, offCalcStat: offCalcStat, defCalcStat: defCalcStat, Power: power, rarity: rarity, typeID: typeID)
     enemySkills.append(skill)
     group.leave()
     }
     }
     } else {
     // Falls es keine Referenzen gibt
     let skill = Skill(id: id, description: description, offCalcStat: offCalcStat, defCalcStat: defCalcStat, Power: power, rarity: 0, typeID: 0)
     enemySkills.append(skill)
     }
     }
     group.leave()
     }
     }
     }
     group.leave()
     }
     
     // 2. Drops über Drops-Sammlung referenzieren
     group.enter()
     self.db.collection("Drops").whereField("EnemyID", isEqualTo: document.reference).getDocuments { dropsSnapshot, error in
     if let error = error {
     print("Error fetching drops: \(error)")
     group.leave()
     return
     }
     
     dropsSnapshot?.documents.forEach { dropDoc in
     let dropData = dropDoc.data()
     if let itemRef = dropData["ID"] as? DocumentReference, let dropRate = dropData["DropRate"] as? Double {
     group.enter()
     itemRef.getDocument { itemSnapshot, error in
     if let itemData = itemSnapshot?.data() {
     let itemID = itemSnapshot?.documentID ?? "Unknown"
     let description = itemData["Description"] as? String ?? ""
     let statBonus = itemData["StatBonus"] as? Int ?? 0
     
     // Item EquipmentClass und Rarity referenzieren
     if let equipmentClassRef = itemData["EquipmentClass"] as? DocumentReference,
     let rarityRef = itemData["Rarity"] as? DocumentReference {
     
     group.enter()
     equipmentClassRef.getDocument { equipmentSnapshot, error in
     let equipmentClassID = equipmentSnapshot?.data()?["EquipmentID"] as? Int ?? 0
     let benefittingStat = equipmentSnapshot?.data()?["BenefittingStat"] as? String ?? ""
     let equipmentClass = EquipmentClass(ID: equipmentClassID, BenefittingStat: benefittingStat)
     group.leave()
     
     group.enter()
     rarityRef.getDocument { raritySnapshot, error in
     let rarity = raritySnapshot?.data()?["Rarity"] as? Int ?? 0
     let item = Item(id: itemID, description: description, equipmentClass: equipmentClass, rarity: rarity, statBonus: statBonus)
     dropItems.append(item)
     group.leave()
     }
     }
     } else {
     // Falls es keine Referenzen gibt
     let item = Item(id: itemID, description: description, equipmentClass: EquipmentClass(ID: 0, BenefittingStat: ""), rarity: 0, statBonus: statBonus)
     dropItems.append(item)
     }
     }
     group.leave()
     }
     }
     }
     group.leave()
     }
     
     // Füge den Enemy hinzu, wenn alle Referenzen aufgelöst sind
     group.notify(queue: .main) {
     let enemy = Enemy(health: health, strength: strength, resistance: resistance, dexterity: dexterity, intelligence: intelligence, willpower: willpower, luck: luck, typeID: typeID, skills: enemySkills, dropItems: dropItems)
     fetchedEnemies.append(enemy)
     }
     group.leave()
     }
     }
     }
     
     // Warten, bis alle Referenzen aufgelöst sind
     group.notify(queue: .main) {
     self.enemies = fetchedEnemies
     print(self.enemies)
     completion()
     }
     }
     */
  }
  }

