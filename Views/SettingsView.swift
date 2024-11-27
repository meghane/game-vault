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
                            Text("View name and email")
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
                        Text("Name")
                        Spacer()
                        Text("\(currentUser.firstName ?? "") \(currentUser.lastName ?? "")")
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
                    
                    Text("The Game Vault is a mobile app designed for gamers on all platforms, helping them find their next gaming obsession. With robust filters for genres, platforms, game types, and more, users can locate and discover video games that are specific to their interests. Regardless of your preference for fantasy RPGs, relaxing simulations, or action-packed survival games, The Game Vault streamlines the search process and introduces you to games you’ll love.")
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
