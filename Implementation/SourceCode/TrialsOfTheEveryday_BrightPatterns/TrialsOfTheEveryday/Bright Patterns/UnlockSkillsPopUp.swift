//
import SwiftUI

struct UnlockSkillsPopUp: View {
    @Environment(\.dismiss) private var dismiss
    
    var gemsAvailable: Int
    var onUnlock: () -> Void
    var onLater: () -> Void
    
    private let unlockCost: Int = 100
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Skills freischalten")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Um deine Skills freizuschalten, sind 100 Magische Staub-Einheiten nötig (Kosten: 100 Gems).")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Du hast \(gemsAvailable) Gems")
                .font(.subheadline)
            
            HStack(spacing: 20) {
                Button(action: {
                    onLater()
                    dismiss()
                }) {
                    Text("Später")
                        .font(.headline)
                        .padding()
                        .frame(width: 120)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    onUnlock()
                    dismiss()
                }) {
                    Text("Freischalten")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(gemsAvailable >= unlockCost ? Color.blue : Color.gray)
                        )
                }
                .disabled(gemsAvailable < unlockCost)
            }
        }
        .padding()
        .frame(width: 350)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 10)
        )
    }
}

struct UnlockSkillsPopUp_Previews: PreviewProvider {
    static var previews: some View {
        Color.gray.opacity(0.3)
            .overlay {
                UnlockSkillsPopUp(
                    gemsAvailable: 150,
                    onUnlock: {},
                    onLater: {}
                )
            }
            .previewLayout(.sizeThatFits)
    }
}

