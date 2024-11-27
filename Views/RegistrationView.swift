//
//  RegistrationView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI
import ParseSwift

struct RegistrationView: View {
    @EnvironmentObject var authStateManager: AuthenticationStateManager
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToHome = false
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            
            //main content
            VStack(alignment: .leading, spacing: 20) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 60)
                
                VStack(alignment: .leading, spacing: 20) {
                    //first name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.system(size: 16))
                        TextField("", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                    }
                    
                    //last name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Name")
                            .font(.system(size: 16))
                        TextField("", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                    }
                    
                    //email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 16))
                        TextField("", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                    }
                    
                    //password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 16))
                        SecureField("", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    //confirm Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.system(size: 16))
                        SecureField("", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Button(action: register) {
                    if authStateManager.authState == .authenticating {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign Up")
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
                    Text("Already have an account?")
                        .foregroundColor(.black)
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Sign in")
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .onChange(of: authStateManager.authState) { newState in
            if newState == .authenticated {
                navigateToHome = true
            }
        }
        .navigationDestination(isPresented: $navigateToHome) {
            HomeView()
        }
    }
    
    private func register() {
        // Validate inputs
        guard !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            showError = true
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            showError = true
            return
        }
        
        // Create new user
        Task {
            do {
                authStateManager.authState = .authenticating
                
                var newUser = GameVaultUser()
                newUser.username = email
                newUser.email = email
                newUser.password = password
                newUser.firstName = firstName
                newUser.lastName = lastName
                
                let user = try await newUser.signup()
                print("Registered user: \(user)")
                
                await MainActor.run {
                    authStateManager.authState = .authenticated
                    let window = UIApplication.shared.windows.first
                    window?.rootViewController = UIHostingController(rootView:
                        MainTabView()
                            .environmentObject(authStateManager)
                    )
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegistrationView()
                .environmentObject(AuthenticationStateManager())
        }
    }
}
