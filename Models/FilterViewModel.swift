//
//  FilterViewModel.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import Foundation

@MainActor
class FilterViewModel: ObservableObject {
    @Published var filteredGames: [Game] = []
    @Published var isLoading = false
    @Published var error: GameError?
    
    private let client = RAWGClient.shared
    
    func applyFilters(
        genres: Set<String>,
        platforms: Set<String>,
        tags: Set<String>,
        ratings: Set<String>,
        gameTypes: Set<String>,
        starRating: String,
        ordering: String
    ) async {
        isLoading = true
        
        do {
            //building the API parameters
            var parameters: [String: String] = [
                "page_size": "40"
            ]
            
            //handling the ordering
            switch ordering {
            case "Name":
                parameters["ordering"] = "name"
            case "Release Date":
                parameters["ordering"] = "-released"
            case "Rating":
                parameters["ordering"] = "-rating"
            case "Metacritic Score":
                parameters["ordering"] = "-metacritic"
            default:
                parameters["ordering"] = "-rating"
            }
            
            //handle ratings (do not allow inappropriate games on trending or recommended)
            if !ratings.isEmpty {
                let ratingIds = ratings.compactMap { rating -> String? in
                    switch rating {
                    case "Everyone": return "1"
                    case "Everyone 10+": return "2"
                    case "Teen": return "3"
                    default: return nil
                    }
                }
                if !ratingIds.isEmpty {
                    parameters["esrb_rating"] = ratingIds.joined(separator: ",")
                }
            }
            
            //handle platforms (convert names to RAWG platform IDs)
            if !platforms.isEmpty {
                let platformIds = platforms.compactMap { platform -> String? in
                    switch platform {
                    case "PC":
                        print("Selected PC")
                        return "4"           // PC
                    case "PlayStation 5":
                        print("Selected PS5")
                        return "187"        // PS5
                    case "PlayStation 4":
                        print("Selected PS4")
                        return "18"         // PS4
                    case "Xbox Series X":
                        print("Selected Xbox Series")
                        return "186"        // Xbox Series X/S
                    case "Xbox One":
                        print("Selected Xbox One")
                        return "1"          // Xbox One
                    case "Nintendo Switch":
                        print("Selected Switch")
                        return "7"          // Switch
                    case "iOS":
                        print("Selected iOS")
                        return "3"          // iOS
                    case "Android":
                        print("Selected Android")
                        return "21"         // Android
                    default:
                        print("Unknown platform: \(platform)")
                        return nil
                    }
                }
                if !platformIds.isEmpty {
                    parameters["platforms"] = platformIds.joined(separator: ",")
                    print("Final platforms parameter: \(parameters["platforms"] ?? "none")")
                }
            }
            
            //handle genres (convert to RAWG slugs)
            if !genres.isEmpty {
                let genreSlugs = genres.map { $0.lowercased().replacingOccurrences(of: " ", with: "-") }
                parameters["genres"] = genreSlugs.joined(separator: ",")
            }
            
            //handle tags
            if !tags.isEmpty {
                let tagSlugs = tags.map { $0.lowercased().replacingOccurrences(of: " ", with: "-") }
                parameters["tags"] = tagSlugs.joined(separator: ",")
            }
            
            print("API Parameters:", parameters) // Debug log
            
            let response: GameResponse = try await client.fetch("games", parameters: parameters)
            print("Found \(response.results.count) games") // Debug log
            
            //client-side filtering
            filteredGames = response.results.filter { game in
                //only filter by rating
                let minRating: Double = switch starRating {
                case "4.5+ Stars": 4.5
                case "4+ Stars": 4.0
                case "3.5+ Stars": 3.5
                case "3+ Stars": 3.0
                default: 0.0
                }
                
                return game.rating >= minRating
            }
            
            print("After filtering: \(filteredGames.count) games") // Debug log
            
            if filteredGames.isEmpty {
                throw GameError.noResults
            }
            //some debugging
            print("API Response games count: \(response.results.count)")
            print("First few games platforms:")
            for game in response.results.prefix(3) {
                print("\(game.name): \(game.platformNames)")
            }
            
        } catch {
            self.error = error as? GameError ?? .networkError(error.localizedDescription)
        }
        
        isLoading = false
    }
}
