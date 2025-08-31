import SwiftUI

struct LimitedGachaOfferView: View {
  @Binding var isPresented: Bool
  @State private var timeRemaining: TimeInterval = 0.5 * 60 // 2 minutes in seconds
  @State private var timer: Timer?
  @State private var showWarningPopup = false
  @State private var confirmationAttempt = 0
  
  var body: some View {
    ZStack {
      // Background overlay
      Color.black.opacity(0.7)
        .ignoresSafeArea()
      
      // Popup content
      VStack(spacing: 15) {
        // Header - centered with less padding
        Text("LIMITED TIME OFFER!")
          .font(.custom("Enchanted Land", size: 50))
          .foregroundStyle(Color.white)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .center)
        
        // Timer
        HStack(spacing: 8) {
          Image(systemName: "timer")
            .foregroundColor(.red)
          
          Text(timeString(from: timeRemaining))
            .font(.title2.monospacedDigit())
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .background(
              RoundedRectangle(cornerRadius: 6)
                .fill(Color.red.opacity(0.3))
            )
        }
        .padding(.vertical, 5)
        
        // Keep the existing FeaturedItemPromotion
        FeaturedItemPromotion()
          .padding(.horizontal)
        
        // Benefit message - compact padding
        HStack {
          Image(systemName: "sparkles")
            .foregroundColor(.yellow)
          
          Text("+5% höhere Dropchance für legendäre Skills")
            .font(.headline)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
          
          Image(systemName: "sparkles")
            .foregroundColor(.yellow)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.purple.opacity(0.4))
        )
        .padding(.horizontal)
        
        // Button styled like GachaOptionCard
        ZStack {
          RoundedRectangle(cornerRadius: 15)
            .fill(Color.gray.opacity(0.7))
            .shadow(radius: 3)
          
          HStack {
            Text("10x Ziehen")
              .font(.title3.bold())
              .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: 4) {
              Text("1000")
              Image(systemSymbol: .diamondCircle)
                .foregroundStyle(Color.purple)
            }
            .foregroundColor(.white)
            
            Button(action: {
              // Action for 10x pull
            }) {
              Text("Ziehen")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(timeRemaining > 0 ? Color.purple : Color.gray)
                .cornerRadius(10)
            }
            .disabled(timeRemaining <= 0)
          }
          .padding(.horizontal)
        }
        .frame(height: 70)
        .padding(.horizontal)
        
        // Keep the hard-to-notice dismiss button but ensure it's visible
        Button(action: {
          showWarningPopup = true
        }) {
          Text("Später")
            .font(.subheadline)
            .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.top, 10)
      }
      .padding(20)
      .background(
        Image("HomeScreenDungeon")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .blur(radius: 2)
          .edgesIgnoringSafeArea(.all)
      )
      .padding(15)
      
      // Warning popup with deliberately confusing buttons
      if showWarningPopup {
        warningPopupView()
      }
    }
    .onAppear {
      startTimer()
    }
    .onDisappear {
      timer?.invalidate()
    }
  }
  
  private func warningPopupView() -> some View {
    let messages = [
      "Wenn du dieses Angebot jetzt schließt, verfällt es automatisch. Möchtest du wirklich fortfahren?",
      "Bist du dir sicher? Dieses Angebot wird nicht noch einmal erscheinen!",
      "Letzte Chance: Dieses Angebot ist einmalig. Bist du dir wirklich sicher?",
      "Letzte Warnung: Du wirst diese erhöhte Dropchance für immer verlieren!"
    ]
    
    return ZStack {
      Color.black.opacity(0.8)
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        Text("ACHTUNG!")
          .font(.title2.bold())
          .foregroundColor(.red)
          .padding(.top)
        
        Text(messages[confirmationAttempt])
          .font(.headline)
          .multilineTextAlignment(.center)
          .foregroundColor(.white)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.horizontal, 20)
          .padding(.vertical, 10)
        
        HStack(spacing: 30) {
          // "No" button styled like a confirmation button (misleading)
          Button(action: {
            showWarningPopup = false
            confirmationAttempt = 0
          }) {
            Text("Nein")
              .font(.headline)
              .foregroundColor(.white)
              .padding()
              .frame(width: 120)
              .background(Color.green)
              .cornerRadius(10)
          }
          
          // "Yes" button styled like a negative button (misleading)
          Button(action: {
            handleConfirmation()
          }) {
            Text("Ja")
              .font(.headline)
              .foregroundColor(.white)
              .padding()
              .frame(width: 120)
              .background(Color.red)
              .cornerRadius(10)
          }
        }
        .padding(.bottom)
      }
      .padding(24)
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.gray.opacity(0.9))
      )
      .frame(maxWidth: 350)
      .padding(40)
    }
  }
  
  private func handleConfirmation() {
    if confirmationAttempt < 3 {
      confirmationAttempt += 1
    } else {
      // Finally close the popup
      showWarningPopup = false
      confirmationAttempt = 0
      isPresented = false
    }
  }
  
  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 1
      } else {
        timer?.invalidate()
      }
    }
  }
  
  private func timeString(from timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}

struct FeaturedItemPromotion: View {
    var body: some View {
        VStack {
            Text("LEGENDÄR")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.orange)
                .cornerRadius(20)
                
            Text("Ziehe nur jetzt die neue legendäre\nPaladin Fähigkeit Smite")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)  // Ensures text displays fully
                .padding(.top, 8)
                
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: 140, height: 140)
                
                Circle()
                    .strokeBorder(Color.orange, lineWidth: 2)
                    .frame(width: 140, height: 140)
                
                Image("activePaladinsSmite")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
            }
            .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.orange, lineWidth: 2)
        )
    }
}
