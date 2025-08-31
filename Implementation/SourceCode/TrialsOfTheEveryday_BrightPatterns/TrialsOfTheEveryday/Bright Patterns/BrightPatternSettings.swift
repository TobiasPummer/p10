import SwiftUI
import SFSafeSymbols

// MARK: - Settings Navigation Structure
struct SettingsView: View {
    @AppStorage("showPlayerFeed") private var showPlayerFeed = true
    @AppStorage("isPremiumActive") private var isPremiumActive = true
    @State private var showPremiumReminder = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Player Feed Toggle
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Spieler-Feed anzeigen", isOn: $showPlayerFeed)
                        .foregroundColor(.white)
                        .tint(.purple)

                    if showPlayerFeed {
                        Text("Dieser Feed basiert auf echten oder simulierten Erfolgen. Du kannst ihn hier deaktivieren.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.4))
                .cornerRadius(10)
                
                // Premium Subscription Status
                if isPremiumActive {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("Gacha Premium")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Aktiv")
                                .font(.subheadline)
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(4)
                        }
                        
                        Text("Du hast Gacha Premium aktiviert. Du kannst es hier verwalten oder kündigen.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Button(action: {
                            showPremiumReminder = true
                        }) {
                            HStack {
                                Text("Abo verwalten")
                                    .fontWeight(.medium)
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.purple)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
                    .alert("Gacha Premium verwalten", isPresented: $showPremiumReminder) {
                        Button("Abbrechen", role: .cancel) {}
                        Button("Abo kündigen", role: .destructive) {
                            isPremiumActive = false
                        }
                    } message: {
                        Text("Möchtest du dein Gacha Premium-Abo kündigen? Du verlierst dann Zugang zu allen Premium-Vorteilen.")
                    }
                }
                
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
        .onAppear {
            checkShowPremiumReminder()
        }
    }
    
    private func checkShowPremiumReminder() {
        // Check if we should show the monthly reminder
        if isPremiumActive {
            let userDefaults = UserDefaults.standard
            let lastReminderKey = "lastPremiumReminderDate"
            
            if let lastReminder = userDefaults.object(forKey: lastReminderKey) as? Date {
                let calendar = Calendar.current
                if let monthsSinceLastReminder = calendar.dateComponents([.month], from: lastReminder, to: Date()).month,
                   monthsSinceLastReminder >= 1 {
                    // It's been at least a month since the last reminder
                    showMonthlyReminder()
                    userDefaults.set(Date(), forKey: lastReminderKey)
                }
            } else {
                // First time checking, set current date
                userDefaults.set(Date(), forKey: lastReminderKey)
            }
        }
    }
    
    private func showMonthlyReminder() {
        // Show the monthly reminder dialog after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showPremiumReminder = true
        }
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
                
                NavigationLink(destination: SubscriptionManagementView()) {
                    HStack {
                        Label("Abonnements", systemImage: "creditcard")
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
    @AppStorage("isPremiumActive") private var isPremiumActive = true
    @State private var showCancellationAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isPremiumActive {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                            Text("Gacha Premium")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 8)
                        
                        Text("Du hast aktuell Gacha Premium aktiviert.")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            PremiumBenefitRow(icon: "sparkles", text: "Täglich 10 Gems gratis")
                            PremiumBenefitRow(icon: "dice", text: "Erhöhte Chance auf Legendaries")
                            PremiumBenefitRow(icon: "wand.and.stars", text: "Exklusive Skins")
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(8)
                        
                        Button("Gacha Premium kündigen") {
                            showCancellationAlert = true
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.black.opacity(0.4)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
                    )
                    .alert("Abo kündigen", isPresented: $showCancellationAlert) {
                        Button("Abbrechen", role: .cancel) {}
                        Button("Kündigen", role: .destructive) {
                            isPremiumActive = false
                        }
                    } message: {
                        Text("Möchtest du Gacha Premium wirklich kündigen? Du verlierst Zugang zu allen Premium-Vorteilen. Dein Abo läuft bis zum Ende des Abrechnungszeitraums weiter.")
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("Kein aktives Abonnement")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Button("Gacha Premium abonnieren") {
                            // Subscription flow would go here
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
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
        .navigationTitle("Abo-Verwaltung")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .background(Color.clear)
    }
}

struct PremiumBenefitRow: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.yellow)
                .font(.system(size: 16))
            
            Text(text)
                .foregroundColor(.white)
                .font(.subheadline)
            
            Spacer()
        }
    }
}
