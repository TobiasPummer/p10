//
//  MissionsView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 18.09.24.
//

import SwiftUI

struct MissionsView: View {
  @ObservedObject var manager: HealthManager
  @Binding var isPresented: Bool
  @AppStorage("finishTasks") private var finishTasks: Bool = false
  @State var ViewState: Int = 1
  @AppStorage("statpoints") private var statpoints: Int = 0
  @AppStorage("StatpointClaimed") private var StatpointClaimed: Bool = false
  @AppStorage("lastResetDate") private var lastResetDate: String = ""
    @State private var timer: Timer?
  
  
  var body: some View {
    ZStack{
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
      .overlay {
        VStack(alignment: .trailing) {
          HStack {
            Spacer()
            Button {
              withAnimation {
                isPresented.toggle()
              }
            } label: {
              Image("Regular_01")
            }
            .padding(.trailing, 40)
          }
          .padding(.top, 45)
          
          Spacer()
        }
        VStack{
          
          Text("Missions")
            .font(Font.custom("Enchanted Land", size: 36))
          
          HStack{
            Spacer()
            Text("What the fuck is a kilometer :")
              .font(Font.custom("Enchanted Land", size: 24))
            Spacer()
          }
          
          HStack{
            Spacer()
            Text("\(manager.stepCount.formattedString()) / 5000")
              .font(Font.custom("Enchanted Land", size: 18))
            Spacer()
          }
          .padding()
          
          HStack{
            Spacer()
            Text("Burned Calories")
              .font(Font.custom("Enchanted Land", size: 24))
            Spacer()
          }
          HStack{
            Spacer()
            Text("\(manager.caloriesCount.formattedString()) / 1800")
              .font(Font.custom("Enchanted Land", size: 18))
            Spacer()
          }
          .padding()
          
          HStack{
            Spacer()
            Text("Hours slept")
              .font(Font.custom("Enchanted Land", size: 24))
            Spacer()
          }
          
          HStack{
            Spacer()
            Text("\(manager.totalSleepHours.formattedString()) / 8 hours")
              .font(Font.custom("Enchanted Land", size: 18))
            Spacer()
          }
          .padding()
          
          if !StatpointClaimed && finishTasks {
            Button {
              withAnimation {
                statpoints += 1
                StatpointClaimed = true
                
              }
            } label: {
              Image("Button_Blue_3Slides")
                .overlay {
                  Text("Finish Daily Tasks")
                    .padding(.bottom, 5)
                    .font(Font.custom("Enchanted Land", size: 28))
                }
            }
            .foregroundStyle(.black)
          }
          
          
          if StatpointClaimed {
            Button {
              
            } label: {
              Image("Button_Blue_3Slides_Pressed")
                .overlay {
                  Text("Tasks Completed")
                    .padding(.bottom, 10)
                    .font(Font.custom("Enchanted Land", size: 28))
                }
            }
            .disabled(true)
            .foregroundStyle(.black)
          }
          if !finishTasks {
            Button {
              
            } label: {
              Image("Button_Blue_3Slides_Pressed")
                .overlay {
                  Text("Tasks to be Completed")
                    .padding(.bottom, 10)
                    .font(Font.custom("Enchanted Land", size: 28))
                }
            }
            .disabled(true)
            .foregroundStyle(.black)
          }
        }
        .onAppear {
          manager.fetchTodaySteps()
          manager.fetchCalories()
          manager.fetchTodaySleepHours()
          finishedTasks()
          setupTimerForDailyReset()
      }
    }
    }
  }
  func resetDailyValues() {
          finishTasks = false
          StatpointClaimed = false
          lastResetDate = currentDateString()
      }
      
      
      func checkForDailyReset() {
          let currentDate = currentDateString()
          
          if lastResetDate != currentDate {
              resetDailyValues()
          }
      }
      
      
      func currentDateString() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          return dateFormatter.string(from: Date())
      }
      
      
      func setupTimerForDailyReset() {
          timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
              let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
              if now.hour == 8 && now.minute == 0 {
                  resetDailyValues()
              }
          }
      }
  
  
  func finishedTasks () {
            let stepGoal = 5000.0
            let caloriesGoal = 1800.0
            let sleepGoal = 8.0
    
    
            let finishedSteps = manager.stepCount >= stepGoal
            let finishedCalories = manager.caloriesCount >= caloriesGoal
            let finishedSleep = manager.totalSleepHours >= sleepGoal
  }
}


extension Double {
  func formattedString() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value: self))!
  }
}


