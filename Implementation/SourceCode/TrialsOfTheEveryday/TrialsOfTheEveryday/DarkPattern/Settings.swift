import SwiftUI
import SFSafeSymbols

// MARK: - Settings Navigation Structure
struct SettingsView: View {
    @AppStorage("showPlayerFeed") private var showPlayerFeed = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Player Feed section without toggle
                VStack(alignment: .leading, spacing: 8) {
                    Text("Spieler-Feed anzeigen")
                        .foregroundColor(.white)
                    
                    Text("Dieser Feed basiert auf echten oder simulierten Erfolgen.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                .padding()
                .background(Color.black.opacity(0.4))
                .cornerRadius(10)
                
                NavigationLink(destination: AccountSettingsView()) {
                    HStack {
                        Label("Account", systemImage: "person.circle")
                            .font(.title3)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .background(Color.clear)
    }
}

struct AccountSettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                NavigationLink(destination: SupportView()) {
                    HStack {
                        Label("Support", systemImage: "questionmark.circle")
                            .font(.title3)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
                }
                
                // You can add more account options here
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("Account")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .background(Color.clear)
    }
}

struct SupportView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                NavigationLink(destination: SubscriptionManagementView()) {
                    HStack {
                        Label("Abo-Verwaltung", systemImage: "creditcard")
                            .font(.title3)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
                }
                
                // You can add more support options here
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("Support")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .background(Color.clear)
    }
}

// MARK: - Subscription Management View
struct SubscriptionManagementView: View {
    @AppStorage("isPremiumActive") private var isPremiumActive = false
    @State private var confirmCancellation = false
    @State private var showCancellationAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isPremiumActive {
                    Text("Aktives Premium-Abonnement")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple.opacity(0.4))
                        .cornerRadius(10)
                    
                    Text("Du hast aktuell Gacha Premium aktiviert. Du kannst hier kündigen.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                    
                    Toggle("Ich bin sicher, dass ich kündigen möchte", isOn: $confirmCancellation)
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(10)
                        .tint(.red)
                        .foregroundColor(.white)
                    
                    Button("Gacha Premium kündigen") {
                        showCancellationAlert = true
                    }
                    .disabled(!confirmCancellation)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(confirmCancellation ? Color.red : Color.gray)
                    )
                    .padding()
                    .alert("Abo gekündigt", isPresented: $showCancellationAlert) {
                        Button("OK") {
                            isPremiumActive = false
                        }
                    } message: {
                        Text("Gacha Premium wurde beendet. Du wirst ab nächstem Monat keine kostenlosen Ziehungen mehr erhalten.")
                    }
                } else {
                    Text("Keine aktiven Abonnements")
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("Abo-Verwaltung")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .background(Color.clear)
    }
}
