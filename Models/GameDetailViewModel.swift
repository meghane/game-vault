//
//  GameDetailViewModel.swift
//  GameVault
//
//  Created by meghan on 11/21/24.
//

import SwiftUI

//more fixes
@MainActor
class GameDetailViewModel: ObservableObject {
    @Published var gameDetails: GameDetails?
    @Published var isLoading = false
    @Published var error: RAWGError?
    
    private let client = RAWGClient.shared
    
    func fetchGameDetails(gameId: Int) async {
        isLoading = true
        
        do {
            gameDetails = try await client.fetch("games/\(gameId)")
        } catch let error as RAWGError {
            self.error = error
        } catch {
            self.error = .networkError(error)
        }
        
        isLoading = false
    }
}
