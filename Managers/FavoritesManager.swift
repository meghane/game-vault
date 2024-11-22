//
//  FavoritesManager.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

//manages the favorites
class FavoritesManager: ObservableObject {
    @Published var favoriteGames: Set<String> = []
    
    func toggleFavorite(gameId: String) {
        if favoriteGames.contains(gameId) {
            favoriteGames.remove(gameId)
        } else {
            favoriteGames.insert(gameId)
        }
    }
    
    func isFavorite(gameId: String) -> Bool {
        favoriteGames.contains(gameId)
    }
}
