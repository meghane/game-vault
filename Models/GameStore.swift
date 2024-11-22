//
//  GameStore.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

@MainActor
class GameStore: ObservableObject {
    @Published var trendingGames: [Game] = []
    @Published var recommendedGames: [Game] = []
    @Published var searchResults: [Game] = []
    @Published var isLoading = false
    @Published var error: GameError?
    
    private let client = RAWGClient.shared
    
    func fetchTrendingGames() async throws {
        isLoading = true
        do {
            var parameters: [String: String] = [
                "ordering": "-rating",
                "page_size": "20",
                "metacritic": "80,100", //high-rated games
                "dates": "2023-01-01,2024-12-31", //recent games
                "exclude_additions": "true", //no DLC
                "parent_platforms": "1,2,3,7" //PC, PlayStation, Xbox, Nintendo
            ]
            
            //add ESRB ratings filter
            parameters["esrb_rating"] = "1,2,3" //Everyone, Everyone 10+, Teen
            
            let response: GameResponse = try await client.fetch(
                "games",
                parameters: parameters
            )
            
            if response.results.isEmpty {
                throw GameError.noResults
            }
            
            trendingGames = response.results
        } catch let error as GameError {
            throw error
        } catch {
            throw GameError.networkError(error.localizedDescription)
        }
        isLoading = false
    }
    
    func fetchRecommendedGames() async throws {
        isLoading = true
        do {
            var parameters: [String: String] = [
                "ordering": "-released",  //most recent first
                "page_size": "20",
                "dates": "\(Date().previousMonth()),\(Date().currentDate())", //last 30 days
                "exclude_additions": "true",
                "parent_platforms": "1,2,3,7"
            ]
            
            //add ESRB ratings filter
            parameters["esrb_rating"] = "1,2,3"
            
            let response: GameResponse = try await client.fetch(
                "games",
                parameters: parameters
            )
            
            if response.results.isEmpty {
                throw GameError.noResults
            }
            
            recommendedGames = response.results
        } catch let error as GameError {
            throw error
        } catch {
            throw GameError.networkError(error.localizedDescription)
        }
        isLoading = false
    }
    
    func searchGames(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        do {
            var parameters: [String: String] = [
                "search": query,
                "page_size": "20",
                "exclude_additions": "true",
                "parent_platforms": "1,2,3,7"
            ]
            
            parameters["esrb_rating"] = "1,2,3"
            
            let response: GameResponse = try await client.fetch(
                "games",
                parameters: parameters
            )
            
            searchResults = response.results
        } catch {
            self.error = GameError.networkError(error.localizedDescription)
        }
        isLoading = false
    }
}

//helper extension for date formatting
private extension Date {
    func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: self)
    }
    
    func previousMonth() -> String {
        let calendar = Calendar.current
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            return formatter.string(from: previousMonth)
        }
        return "01-01-2023" //fallback date
    }
}
