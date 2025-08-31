import SwiftUI

struct DungeonOverviewView: View {
    @State private var selectedTab = 0
    @Binding var ViewState: Int
    var enemies: [Enemy] = []
    var viewModel: DataContainerViewModel
    @AppStorage("health") private var health: Int = 0
    @AppStorage("strength") private var strength: Int = 0
    @AppStorage("resistance") private var resistance: Int = 0
    @AppStorage("dexterity") private var dexterity: Int = 0
    @AppStorage("intelligence") private var intelligence: Int = 0
    @AppStorage("willpower") private var willpower: Int = 0
    @AppStorage("selectedHelmet") private var selectedHelmet: String = ""
    @AppStorage("selectedChestplate") private var selectedChestplate: String = ""
    @AppStorage("selectedBoots") private var selectedBoots: String = ""
    @AppStorage("selectedWeapon") private var selectedWeapon: String = ""
    @AppStorage("selectedRing") private var selectedRing: String = ""
    @AppStorage("selectedAmulett") private var selectedAmulett: String = ""
    @AppStorage("stamina") private var stamina: Int = 0
    @State private var isNavigating = false

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                Image("00_Banner_Vertical").resizable()
                Image("01_Banner_Vertical").resizable()
                Image("01_Banner_Vertical").resizable()
                Image("01_Banner_Vertical").resizable()
                Image("01_Banner_Vertical").resizable()
                Image("01_Banner_Vertical").resizable()
                Image("01_Banner_Vertical").resizable()
                Image("02_Banner_Vertical").resizable()
            }

            ForEach(0..<10, id: \.self) { _ in
                GridRow {
                    Image("03_Banner_Vertical").resizable()
                    Image("04_Banner_Vertical").resizable()
                    Image("04_Banner_Vertical").resizable()
                    Image("04_Banner_Vertical").resizable()
                    Image("04_Banner_Vertical").resizable()
                    Image("04_Banner_Vertical").resizable()
                    Image("04_Banner_Vertical").resizable()
                    Image("05_Banner_Vertical").resizable()
                }
            }

            GridRow {
                Image("06_Banner_Vertical").resizable()
                Image("07_Banner_Vertical").resizable()
                Image("07_Banner_Vertical").resizable()
                Image("07_Banner_Vertical").resizable()
                Image("07_Banner_Vertical").resizable()
                Image("07_Banner_Vertical").resizable()
                Image("07_Banner_Vertical").resizable()
                Image("08_Banner_Vertical").resizable()
            }
        }
        .overlay {
            ZStack {
                VStack {
                    Text("Dungeon Name")
                        .font(Font.custom("Enchanted Land", size: 36))
                        .padding(.top, 50)

                    HStack(alignment: .center, spacing: 30) {
                        Text("Wave 1")
                            .foregroundColor(selectedTab == 0 ? .red : .black)
                            .animation(.easeInOut, value: selectedTab)
                            .font(Font.custom("Enchanted Land", size: 24))
                            .onTapGesture { withAnimation { selectedTab = 0 } }

                        Text("Wave 2")
                            .foregroundColor(selectedTab == 1 ? .red : .black)
                            .animation(.easeInOut, value: selectedTab)
                            .font(Font.custom("Enchanted Land", size: 24))
                            .onTapGesture { withAnimation { selectedTab = 1 } }

                        Text("Wave 3")
                            .foregroundColor(selectedTab == 2 ? .red : .black)
                            .animation(.easeInOut, value: selectedTab)
                            .font(Font.custom("Enchanted Land", size: 24))
                            .onTapGesture { withAnimation { selectedTab = 2 } }
                    }
                    .padding(.top, 20)

                    TabView(selection: $selectedTab) {
                        ExtractedView(enemyCount: 1).tag(0)
                        ExtractedView(enemyCount: 1).tag(1)
                        ExtractedView(enemyCount: 1).tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(.page(backgroundDisplayMode: .never))
                    .padding(.horizontal, 40)

                    Text("Stamina")
                        .font(Font.custom("Enchanted Land", size: 24))

                    Text("\(stamina)/2")
                        .font(Font.custom("Enchanted Land", size: 24))

                    Button(action: {
                        if stamina >= 2 {
                            stamina -= 2
                            isNavigating = true // Navigation nur bei genug Stamina
                        }
                    }) {
                        Image("Button_Blue_3Slides")
                            .overlay {
                                Text("Start")
                                    .padding(.bottom)
                                    .foregroundStyle(.black)
                                    .font(Font.custom("Enchanted Land", size: 24))
                            }
                    }
                    .disabled(stamina < 2)
                    .padding(.bottom, 60)

                    NavigationLink(
                        destination: DungeonView(
                            enemy: enemies[0],
                            character: Character(
                                health: health,
                                strength: strength,
                                resistance: resistance,
                                dexterity: dexterity,
                                intelligence: intelligence,
                                willpower: willpower,
                                luck: Int.random(in: 1...100),
                                skills: viewModel.skills
                            ),
                            health: health,
                            enemyHealth: enemies[0].health
                        ),
                        isActive: $isNavigating
                    ) {
                        EmptyView() // Versteckte Navigation
                    }
                }

                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button {
                            ViewState = 1
                        } label: {
                            Image("Regular_01")
                        }
                        .padding(.trailing, 30)
                    }
                    .padding(.top, 45)

                    Spacer()
                }
            }
        }
    }
}

struct ExtractedView: View {
    let enemyCount: Int

    var body: some View {
        VStack {
            HStack {
                if enemyCount == 1 {
                    PixelAnimationView(imageNames: CharacterImages.goblin.imageNames, fps: 10)
                        .scaledToFit()
                        .frame(width: 200)
                }
                if enemyCount >= 2 {
                    PixelAnimationView(imageNames: CharacterImages.goblin.imageNames, fps: 10)
                        .scaledToFit()
                        .frame(width: 200)
                    PixelAnimationView(imageNames: CharacterImages.goblin.imageNames, fps: 10)
                        .scaledToFit()
                        .frame(width: 200)
                }
            }

            if enemyCount == 3 {
                HStack {
                    PixelAnimationView(imageNames: CharacterImages.goblin.imageNames, fps: 10)
                        .scaledToFit()
                        .frame(width: 200)
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(0.1)).padding(.horizontal, 50))
    }
}
