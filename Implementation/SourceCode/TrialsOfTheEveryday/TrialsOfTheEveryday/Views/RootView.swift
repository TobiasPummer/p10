//
//  NavigationBarView.swift
//  TrialsOfTheEveryday
//
//  Created by Tobias Pummer on 09.09.24.
//

import SFSafeSymbols
import SwiftUI

struct RootView: View {
    @State var ViewState: Int = 1
    @State var showMissions: Bool = false
    @StateObject var viewModel: DataContainerViewModel
    @ObservedObject var manager: HealthManager
    @State private var showFakeAchievements: Bool = false
    @StateObject private var currency = GameCurrency.shared

  var body: some View {
    NavigationStack {
      ZStack {
        VStack {
          TopBarView(manager: manager, currency: currency)

          if ViewState == 1 {
            HStack {
              Spacer()

              ShowMissionsView(showMissions: $showMissions)
                .padding(.trailing, 10)
            }
          }

          if ViewState == 0 {
            PlayerScreenView(
              helmets: viewModel.helmets, chestplates: viewModel.chestplates,
              boots: viewModel.boots, weapons: viewModel.weapons,
              rings: viewModel.rings, amuletts: viewModel.amuletts,
              skills: viewModel.skills
            )
            .onAppear {
              manager.fetchTodaySteps()
            }

          } else if ViewState == 1 {
            HomeScreenView(ViewState: $ViewState)
              .onAppear {
                manager.fetchTodaySteps()
              }
          } else if ViewState == 2 {
            GachaShopView(viewState: $ViewState, currency: currency)
              .onAppear{
                manager.fetchTodaySteps()
              }
              
//            UnlockSkillsPopUp(
//                    gemsAvailable: gems,
//                    onUnlock: {
//                        // Logic for when user unlocks skills
//                        if gems >= 100 {
//                            gems -= 100
//                            // Add logic here for what happens when skills are unlocked
//                        }
//                    },
//                    onLater: {
//                        // Logic for when the user chooses "Later"
//                        ViewState = 1 // Return to home screen
//                    }
//                )
//                .onAppear {
//                    manager.fetchTodaySteps()
//                }
//
//           DrawAgainPopUp(
//               gemsAvailable: gems,
//               onDraw: {
//                   // Logic for when user draws
//                   if gems >= 50 {
//                       gems -= 50
//                       // Add logic here for what happens when items are drawn
//                   }
//               },
//               onClose: {
//                   // Logic for when the popup is closed
//                   ViewState = 1 // Return to home screen when closed
//               }
//           )
//           .onAppear {
//               manager.fetchTodaySteps()
//           }
          } else if ViewState == 3 {
            DungeonOverviewView(
              ViewState: $ViewState, enemies: viewModel.enemies,
              viewModel: viewModel
            )
            .onAppear {
              manager.fetchTodaySteps()
            }
          }
          
          else if ViewState == 4 {
            SettingsView()
                   .onAppear {
                       manager.fetchTodaySteps()
                   }
          }

          NavigationBarView(ViewState: $ViewState)  // NavBar unten
        }
        .background(Image("HomeScreenDungeon"))
        .disabled(showMissions)

        if showMissions {
          MissionsView(manager: manager, isPresented: $showMissions)
        }

        if showFakeAchievements {
          FakeAchievmentsOtherPlayers()
            .zIndex(100)  // Ensure it's on top of everything
        }
      }
      .onAppear {
        viewModel.filterItems()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.showFakeAchievements = true
        }
      }
    }
  }
}
/*
#Preview {
  RootView(viewModel: DataContainerViewModel(), manager: manager)
}
 */

struct TopBarView: View {
  var manager: HealthManager
  @ObservedObject var currency: GameCurrency

  var body: some View {
    ZStack {
      WoodBackgroundView()

      HStack(spacing: 80) {
        Group {
          HStack {
            Image(systemSymbol: .boltCircle)
              .foregroundStyle(Color.blue)
              .background(Color.black.clipShape(Circle()))
            Text("\(currency.stamina)")
              .font(Font.custom("Enchanted Land", size: 40))
          }

          HStack {
            Image(systemSymbol: .diamondCircle)
              .foregroundStyle(Color.purple)
              .background(Color.black.clipShape(Circle()))
            Text("\(currency.gems)")
              .font(Font.custom("Enchanted Land", size: 40))
          }

          HStack {
            Image(systemSymbol: .centsignCircle)
              .foregroundStyle(Color.yellow)
              .background(Color.black.clipShape(Circle()))
            Text("\(currency.coins)")
              .font(Font.custom("Enchanted Land", size: 40))
          }
        }
        .font(.title)
        .foregroundStyle(Color.white)
      }
      .padding(.bottom, 5)
    }
    .onAppear {
      manager.fetchTodaySteps()
    }
  }
}

struct NavigationBarView: View {
  @Binding var ViewState: Int

  var body: some View {
    ZStack {
      WoodBackgroundView()

      HStack(alignment: .center, spacing: 80) {
        Image(systemSymbol: .personCircleFill)
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.black)
          .background(
            Circle().foregroundStyle(ViewState == 0 ? Color.green : Color.white)
          )
          .onTapGesture {
            withAnimation {
              ViewState = 0
            }
          }

        Image(systemSymbol: .houseCircleFill)
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.black)
          .background(
            Circle().foregroundStyle(ViewState == 1 ? Color.green : Color.white)
          )
          .onTapGesture {
            withAnimation {
              ViewState = 1
            }
          }

        Image(systemSymbol: .cartCircleFill)
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.black)
          .background(
            Circle().foregroundStyle(ViewState == 2 ? Color.green : Color.white)
          )
          .onTapGesture {
            withAnimation {
              ViewState = 2
            }
          }
        
        Image(systemSymbol: .gearshapeCircleFill)
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.black)
          .background(
            Circle().foregroundStyle(ViewState == 4 ? Color.green : Color.white)
          )
          .onTapGesture {
            withAnimation {
              ViewState = 4
            }
          }
      }
      .frame(height: 50)
      .padding(.bottom, 5)
    }
  }
}

struct WoodBackgroundView: View {
  var body: some View {
    Grid(horizontalSpacing: 0, verticalSpacing: 0) {
      GridRow {
        Image("01_Bridge_All")
          .resizable()
        Image("01_Bridge_All")
          .resizable()
        Image("01_Bridge_All")
          .resizable()
        Image("01_Bridge_All")
          .resizable()
        Image("01_Bridge_All")
          .resizable()
      }
    }
    .frame(height: 80)
  }
}

struct ShowMissionsView: View {
  @Binding var showMissions: Bool

  var body: some View {
    VStack(alignment: .trailing) {
      Image("02")
        .overlay {
          Image(systemSymbol: .exclamationmark)
            .resizable()
            .scaledToFit()
            .padding(.top, 5)
            .padding(.bottom, 5)
            .foregroundStyle(Color.white)
        }
        .onTapGesture {
          withAnimation {
            showMissions.toggle()
          }
        }
    }
  }
}
