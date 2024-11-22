//
//  GameVaultApp.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI
import ParseSwift

//connects the managers to the app
@main
struct GameVaultApp: App {
    @StateObject private var authStateManager = AuthenticationStateManager()
    @StateObject private var favoritesManager = FavoritesManager()  // Add this
        
    init() {
        initializeParse()
    }
    //enables the launchscreen to be the first view
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environmentObject(authStateManager)
                .environmentObject(favoritesManager)
        }
    }
  //initializes parse
    private func initializeParse() {
        ParseSwift.initialize(
            applicationId: ParseConfig.applicationId,
            clientKey: ParseConfig.clientKey,
            serverURL: URL(string: ParseConfig.serverURL)!
        )
    }
}

