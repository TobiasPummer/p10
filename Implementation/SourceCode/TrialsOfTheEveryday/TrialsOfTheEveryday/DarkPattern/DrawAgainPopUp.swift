
import SwiftUI

struct DrawAgainPopUp: View {
    @State private var autoDrawAgain: Bool = true
    @Environment(\.dismiss) private var dismiss
    @State private var isDrawing: Bool = false
    @State private var showInsufficientGemsAlert: Bool = false
    
    var gemsAvailable: Int
    var gemsCost: Int = 50
    var onDraw: () -> Void
    var onClose: () -> Void
    
    var body: some View {
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
            
            HStack {
                Image(systemName: autoDrawAgain ? "checkmark.square.fill" : "square")
                    .foregroundColor(autoDrawAgain ? .blue : .gray)
                    .onTapGesture {
                        autoDrawAgain.toggle()
                    }
                
                Text("Automatisch erneut ziehen, wenn genug Gems vorhanden (vorausgewählt)")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Button("Schließen") {
                onClose()
                dismiss()
            }
            .padding(.top)
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
      Spacer()
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
            if autoDrawAgain && gemsAvailable - gemsCost >= gemsCost {
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
                    gemsAvailable: 150, 
                    onDraw: {},
                    onClose: {}
                )
            }
            .previewLayout(.sizeThatFits)
    }
}
