//
//  FavoriteGameViewModel.swift
//  GameVault
//
//  Created by meghan on 11/21/24.
//
import SwiftUI

//defined the viewmodel
@MainActor
class FavoriteGameViewModel: ObservableObject {
    @Published var gameDetails: GameDetails?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let client = RAWGClient.shared
    
    //fetcching game details
    func fetchGameDetails(gameId: String) async {
        isLoading = true
        
        do {
            gameDetails = try await client.fetch("games/\(gameId)")
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
