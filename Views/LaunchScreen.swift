//
//  LaunchScreen.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

struct LaunchScreen: View {
    @StateObject private var authStateManager = AuthenticationStateManager()
    @State private var showingSignIn = false
    @State private var showingRegistration = false
    
    var body: some View {
        if authStateManager.authState == .authenticated {
            MainTabView()
                .environmentObject(authStateManager)
        } else {
            ZStack {
                //background circles
                Circle()
                    .fill(.black)
                    .frame(width: 100)
                    .position(x: -20, y: -20)
                
                Circle()
                    .fill(.black)
                    .frame(width: 50)
                    .position(x: UIScreen.main.bounds.width - 30, y: 40)
                
                Circle()
                    .fill(.black)
                    .frame(width: 100)
                    .position(x: -20, y: UIScreen.main.bounds.height - 20)
                
                Circle()
                    .fill(.black)
                    .frame(width: 100)
                    .position(x: UIScreen.main.bounds.width - 20, y: UIScreen.main.bounds.height - 20)
                
                //main content
                VStack(spacing: 20) {
                    Spacer()
                    
                    //logo placeholder
                    VStack(spacing: 8) {
                        Text("GAME VAULT")
                            .font(.system(size: 32, weight: .bold))
                    }
                    
                    Spacer()
                    
                    //buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            showingSignIn = true
                        }) {
                            Text("Sign in")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showingRegistration = true
                        }) {
                            Text("Create an account")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .underline()
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
            .background(Color.white)
            .ignoresSafeArea()
            .sheet(isPresented: $showingSignIn) {
                NavigationStack {
                    SignInView()
                        .environmentObject(authStateManager)
                }
            }
            .sheet(isPresented: $showingRegistration) {
                NavigationStack {
                    RegistrationView()
                        .environmentObject(authStateManager)
                }
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
