import SwiftUI

struct DrawAgainPopUp: View {
    @State private var autoDrawAgain: Bool = false // Not pre-selected
    @Environment(\.dismiss) private var dismiss
    @State private var isDrawing: Bool = false
    @State private var showInsufficientGemsAlert: Bool = false
    @State private var showAutoDrawConfirmation: Bool = false
    @State private var showAdditionalGemsInfo: Bool = false
    
    var gemsAvailable: Int
    var gemsCost: Int = 50
    var onDraw: () -> Void
    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()
                Text("Gacha-Ziehung")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Du hast \(gemsAvailable) Gems")
                    .font(.subheadline)
                
                Button(action: {
                    performDraw()
                }) {
                    Text("10x Ziehen")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                }
                .disabled(isDrawing || gemsAvailable < gemsCost)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: autoDrawAgain ? "checkmark.square.fill" : "square")
                            .foregroundColor(autoDrawAgain ? .blue : .gray)
                            .onTapGesture {
                                if !autoDrawAgain {
                                    showAutoDrawConfirmation = true
                                } else {
                                    autoDrawAgain = false
                                    showAdditionalGemsInfo = false
                                }
                            }
                        
                        Text("Nach dem Ziehen erneut 10x ziehen, wenn genug Gems vorhanden (nicht vorausgewählt)")
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    if showAdditionalGemsInfo {
                        Text("Es werden 1000 zusätzliche Gems benötigt.")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal)
                
                Button("Schließen") {
                    onClose()
                    dismiss()
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .frame(width: 350)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 10)
            )
            .alert("Nicht genügend Gems", isPresented: $showInsufficientGemsAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Du benötigst \(gemsCost) Gems für eine Ziehung.")
            }
            
            if showAutoDrawConfirmation {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showAutoDrawConfirmation = false
                    }
                
                VStack(spacing: 16) {
                    Text("Automatischen Zug bestätigen")
                        .font(.headline)
                    
                    Text("Es werden 1000 zusätzliche Gems für den automatischen zweiten Zug benötigt. Möchtest du fortfahren?")
                        .font(.body)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 20) {
                        Button("Abbrechen") {
                            showAutoDrawConfirmation = false
                        }
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        
                        Button("Bestätigen") {
                            autoDrawAgain = true
                            showAdditionalGemsInfo = true
                            showAutoDrawConfirmation = false
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding(.horizontal, 40)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showAdditionalGemsInfo)
        .animation(.easeInOut, value: showAutoDrawConfirmation)
    }
    
    private func performDraw() {
        guard gemsAvailable >= gemsCost else {
            showInsufficientGemsAlert = true
            return
        }
        
        isDrawing = true
        
        onDraw()
        
        // Simulate drawing process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isDrawing = false
            
            // Auto-draw again if option is enabled and enough gems remain
            if autoDrawAgain && gemsAvailable - gemsCost >= 1000 {
                performDraw()
            }
        }
    }
}

struct DrawAgainPopUp_Previews: PreviewProvider {
    static var previews: some View {
        Color.gray.opacity(0.3)
            .overlay {
                DrawAgainPopUp(
                    gemsAvailable: 1500,
                    onDraw: {},
                    onClose: {}
                )
            }
            .previewLayout(.sizeThatFits)
    }
}
