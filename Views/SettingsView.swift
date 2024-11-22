//
//  SettingsView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI
import ParseSwift

struct SettingsView: View {
    @EnvironmentObject var authStateManager: AuthenticationStateManager
    @State private var showProfile = false
    @State private var showAbout = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Profile") {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Text("View username and email")
                            Spacer()
                        }
                    }
                }
                
                Section("Settings") {
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Text("About")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

//profile View
struct ProfileView: View {
    @EnvironmentObject var authStateManager: AuthenticationStateManager
    
    var body: some View {
        List {
            if let currentUser = GameVaultUser.current {
                Section {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(currentUser.username ?? "")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(currentUser.email ?? "")
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button(role: .destructive, action: signOut) {
                        Text("Sign Out")
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .listStyle(InsetGroupedListStyle())
    }
    
    private func signOut() {
        Task {
            do {
                try await GameVaultUser.logout()
                await MainActor.run {
                    authStateManager.authState = .unauthenticated
                }
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
}

//about View
struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("GameVault")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0")
                        .foregroundColor(.gray)
                    
                    Text("GameVault is your personal game collection manager and discovery tool.")
                        .padding(.top, 8)
                }
                .padding(.vertical, 8)
            }
            
            Section("Legal") {
                Link("Privacy Policy", destination: URL(string: "https://your-privacy-policy-url.com")!)
                Link("Terms of Service", destination: URL(string: "https://your-terms-url.com")!)
            }
        }
        .navigationTitle("About")
        .listStyle(InsetGroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthenticationStateManager())
    }
}
