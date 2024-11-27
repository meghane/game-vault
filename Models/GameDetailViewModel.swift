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
    @Published var trailerUrl: String?
    
    private let client = RAWGClient.shared
    
    func fetchGameDetails(gameId: Int) async {
        isLoading = true
        
        do {
            gameDetails = try await client.fetch("games/\(gameId)")
            // Fetch trailer if available
            if let movieData: MovieResponse = try? await client.fetch("games/\(gameId)/movies") {
                trailerUrl = movieData.results.first?.data.max
            }
        } catch let error as RAWGError {
            self.error = error
        } catch {
            self.error = .networkError(error)
        }
        
        isLoading = false
    }
}

//add these structures for trailer data
struct MovieResponse: Codable {
    let results: [MovieResult]
}

struct MovieResult: Codable {
    let data: MovieData
}

struct MovieData: Codable {
    let max: String //URL for the video
}
