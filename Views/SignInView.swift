//
//  SignInView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI
import ParseSwift

struct SignInView: View {
    @EnvironmentObject var authStateManager: AuthenticationStateManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showingRegistration = false
    
    var body: some View {
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
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome Back!")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 60)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 16))
                        TextField("", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 16))
                        SecureField("", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Button(action: signIn) {
                    if authStateManager.authState == .authenticating {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign In")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black)
                .cornerRadius(8)
                .padding(.top, 20)
                .disabled(authStateManager.authState == .authenticating)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.black)
                    NavigationLink {
                        RegistrationView()
                            .environmentObject(authStateManager)
                    } label: {
                        Text("Sign up")
                            .foregroundColor(.black)
                            .underline()
                    }
                }
                .font(.system(size: 16))
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .background(Color.white)
        .ignoresSafeArea()
        .navigationDestination(isPresented: $showingRegistration) {
            RegistrationView()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    private func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            showError = true
            return
        }
        
        Task {
            do {
                authStateManager.authState = .authenticating
                let user = try await GameVaultUser.login(username: email, password: password)
                print("Logged in user: \(user)")
                await MainActor.run {
                    authStateManager.authState = .authenticated
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    authStateManager.authState = .unauthenticated
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
                .environmentObject(AuthenticationStateManager())
        }
    }
}
