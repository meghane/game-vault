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
        
        do {
            let parameters = ["search": query, "page_size": "20"]
            let response: GameResponse = try await client.fetch("games", parameters: parameters)
            searchResults = response.results
        } catch {
            self.error = error as? GameError ?? .networkError(error.localizedDescription)
        }
        
        isLoading = false
    }
}
