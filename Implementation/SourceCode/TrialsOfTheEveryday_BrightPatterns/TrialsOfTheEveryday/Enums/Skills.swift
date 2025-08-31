enum SkillRarity: String {
    case common = "Häufig"
    case rare = "Selten"
    case epic = "Episch"
    case legendary = "Legendär"
}

enum SkillCategory: String {
    case offense = "Offensiv"
    case defense = "Defensiv"
    case magic = "Magisch"
    case support = "Unterstützend"
}

struct GameSkill {
    let name: String
    let description: String
    let rarity: SkillRarity
    let category: SkillCategory
}

let gachaSkills: [GameSkill] = [
    GameSkill(name: "Flammenstoß", description: "Schleudert einen Feuerball, der Flächenschaden verursacht.", rarity: .rare, category: .offense),
    GameSkill(name: "Donnerschlag", description: "Ein mächtiger Nahkampfangriff, der Gegner kurzzeitig betäubt.", rarity: .epic, category: .offense),
    GameSkill(name: "Schattendolch", description: "Rascher Angriff aus dem Hinterhalt mit erhöhtem Krit.", rarity: .common, category: .offense),
    GameSkill(name: "Frostklinge", description: "Verlangsamt getroffene Feinde und fügt Eisschaden zu.", rarity: .rare, category: .offense),
    GameSkill(name: "Drachenzorn", description: "Entfesselt die Wut eines Drachen und setzt das Schlachtfeld in Brand.", rarity: .legendary, category: .offense),
    
    GameSkill(name: "Magischer Schild", description: "Absorbiert für kurze Zeit eingehenden Schaden.", rarity: .rare, category: .defense),
    GameSkill(name: "Eiserne Haut", description: "Erhöht die physische Verteidigung stark.", rarity: .common, category: .defense),
    GameSkill(name: "Heiliger Wall", description: "Schützt die gesamte Gruppe vor dunkler Magie.", rarity: .epic, category: .defense),
    GameSkill(name: "Standhaftigkeit", description: "Reduziert Rückstoß- und Kontroll-Effekte für kurze Zeit.", rarity: .common, category: .defense),
    GameSkill(name: "Göttliche Intervention", description: "Verhindert einmalig den Tod eines Verbündeten.", rarity: .legendary, category: .defense),
    
    GameSkill(name: "Arkane Welle", description: "Magische Druckwelle, die Gegner zurückstößt.", rarity: .common, category: .magic),
    GameSkill(name: "Gedankenkontrolle", description: "Übernimmt für kurze Zeit einen schwachen Feind.", rarity: .rare, category: .magic),
    GameSkill(name: "Zeitkrümmung", description: "Lässt den Benutzer für wenige Sekunden doppelt so schnell agieren.", rarity: .epic, category: .magic),
    GameSkill(name: "Schattenportal", description: "Teleportiert den Nutzer an einen sicheren Ort.", rarity: .rare, category: .magic),
    GameSkill(name: "Runensalve", description: "Löst alte Runen aus, die zufällige Effekte erzeugen.", rarity: .common, category: .magic),
    
    GameSkill(name: "Lebensfunke", description: "Regeneriert über Zeit Lebenspunkte eines Verbündeten.", rarity: .common, category: .support),
    GameSkill(name: "Kampfruf", description: "Erhöht temporär den Angriffswert aller Gruppenmitglieder.", rarity: .rare, category: .support),
    GameSkill(name: "Alchemistisches Elixier", description: "Stellt Lebens- und Manapunkte wieder her.", rarity: .rare, category: .support),
    GameSkill(name: "Geisterblick", description: "Enthüllt versteckte Feinde und Fallen.", rarity: .epic, category: .support),
    GameSkill(name: "Segen der Ahnen", description: "Verstärkt dauerhaft einen zufälligen Skill des Nutzers.", rarity: .legendary, category: .support)
]
