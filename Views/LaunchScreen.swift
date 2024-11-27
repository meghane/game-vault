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
                
                //main content
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 100)
                    
                    //logo
                    VStack(spacing: 8) {
                        Image("gamevaultlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                    }
                    
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
