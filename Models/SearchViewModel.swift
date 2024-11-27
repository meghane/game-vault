//
//  SearchViewModel.swift
//  GameVault
//
//  Created by meghan on 11/21/24.
//

import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchResults: [Game] = []
    @Published var isLoading = false
    @Published var error: GameError?
    
    private let client = RAWGClient.shared
    
    func searchGames(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let parameters = [
                "search": query.trimmingCharacters(in: .whitespacesAndNewlines),
                "page_size": "20",
                "search_precise": "true",
                "exclude_additions": "true",
                "exclude_tags": "sexual-content,nudity,nsfw",
                "ordering": "-relevance,-rating",
                "key": "4286de6535b0405c8a5d648c35b6ddee"
            ]
            
            let response: GameResponse = try await client.fetch("games", parameters: parameters)
            
            guard !response.results.isEmpty else {
                searchResults = []
                return
            }
            
            searchResults = response.results
        } catch let error as GameError {
            self.error = error
        } catch {
            self.error = .networkError("Failed to load search results. Please try again.")
        }
        
        isLoading = false
    }
}
