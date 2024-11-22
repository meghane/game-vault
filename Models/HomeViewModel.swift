//
//  HomeViewModel.swift
//  GameVault
//
//  Created by meghan on 11/21/24.
//

import SwiftUI
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let client = RAWGClient.shared
    
    //eliminated inappropriate games appearing in trending and recommended carousels
    func fetchGames() async {
        isLoading = true
        do {
            let parameters = [
                "page_size": "20",
                "ordering": "-rating",
                "exclude_tags": "sexual-content,nudity,nsfw",
                "exclude_additions": "true",
                "metacritic": "60,100",
                "tags": "singleplayer,multiplayer,action,adventure",
                "stores": "1,2,3,4,5,6"
            ]
            
            let response: GameResponse = try await client.fetch("games", parameters: parameters)
            self.games = response.results
            isLoading = false
        } catch {
            print("❌ Error fetching games: \(error)")
            self.error = error
            isLoading = false
        }
    }
    
    func fetchRecommendedGames() async {
    }
}
