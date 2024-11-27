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
    @Published var trendingGames: [Game] = []
    @Published var recommendedGames: [Game] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let client = RAWGClient.shared
    
    func fetchGames() async {
        isLoading = true
        do {
            // Fetch trending games
            let trendingParameters = [
                "page_size": "20",
                "ordering": "-rating",
                "exclude_tags": "sexual-content,nudity,nsfw",
                "exclude_additions": "true",
                "metacritic": "60,100",
                "tags": "singleplayer,multiplayer,action,adventure",
                "stores": "1,2,3,4,5,6"
            ]
            
            let trendingResponse: GameResponse = try await client.fetch("games", parameters: trendingParameters)
            self.trendingGames = trendingResponse.results
            
            // Fetch recommended games with different parameters
            let recommendedParameters = [
                "page_size": "20",
                "ordering": "-metacritic", // Different ordering
                "exclude_tags": "sexual-content,nudity,nsfw",
                "exclude_additions": "true",
                "metacritic": "80,100", // Higher metacritic score
                "tags": "singleplayer,multiplayer,rpg,story-rich", // Different tags
                "stores": "1,2,3,4,5,6"
            ]
            
            let recommendedResponse: GameResponse = try await client.fetch("games", parameters: recommendedParameters)
            self.recommendedGames = recommendedResponse.results
            
            isLoading = false
        } catch {
            print("❌ Error fetching games: \(error)")
            self.error = error
            isLoading = false
        }
    }
}
