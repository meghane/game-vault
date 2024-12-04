//
//  AuthenticationStateManager.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI
import ParseSwift

enum AuthState {
    case authenticated
    case unauthenticated
    case authenticating
}

@MainActor
class AuthenticationStateManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var authState: AuthState = .unauthenticated
    
    init() {
        //checks to see if the user is alreading logged in
        if let user = User.current {
            self.currentUser = user
            self.isAuthenticated = true
            self.authState = .authenticated
        }
    }
    //signin
    func signIn(username: String, password: String) async throws {
        authState = .authenticating
        do {
            let user = try await User.login(username: username, password: password)
            self.currentUser = user
            self.isAuthenticated = true
            self.authState = .authenticated
            print("Logged in user: \(String(describing: user.username))")
        } catch {
            print("Error logging in: \(error)")
            self.authState = .unauthenticated
            throw error
        }
    }
    //signout
    func signOut() {
        do {
            try User.logout()
            self.currentUser = nil
            self.isAuthenticated = false
            self.authState = .unauthenticated
        } catch {
            print("Error logging out: \(error)")
        }
    }
    //makes the currentuser the currentuser
    func getCurrentUser() -> any ParseUser {
        return User.current ?? User()
    }
}

