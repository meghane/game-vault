//
//  GameView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI
import Foundation

enum GameError: LocalizedError {
    case failedToFetch
    case noResults
    case invalidData
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .failedToFetch:
            return "Unable to fetch games. Please try again later."
        case .noResults:
            return "No games found."
        case .invalidData:
            return "There was a problem loading the games."
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}
