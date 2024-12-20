//
//  FilterOptions.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import Foundation

//filter options
struct FilterOptions {
    //genres filter
    static let genres = [
        "Action",
        "Adventure",
        "Arcade",
        "Board Games",
        "Card",
        "Casual",
        "Educational",
        "Family",
        "Fighting",
        "Indie",
        "Massively Multiplayer",
        "Platformer",
        "Puzzle",
        "Racing",
        "RPG",
        "Shooter",
        "Simulation",
        "Sports",
        "Strategy"
    ]
    //platforms filter
    static let platforms = [
        "PC",
        "PlayStation 5",
        "PlayStation 4",
        "Xbox Series X",
        "Xbox One",
        "Nintendo Switch",
        "iOS",
        "Android",
        "macOS",
        "Linux"
    ]
    //tags filter
    static let tags = [
        "Singleplayer",
        "Multiplayer",
        "Co-op",
        "Online Co-op",
        "Local Co-op",
        "PvP",
        "Online PvP",
        "Local PvP",
        "Split Screen",
        "Cross-Platform",
        "Controller Support",
        "Cloud Saves",
        "Achievement"
    ]
    //ratings filter
    static let esrbRatings = [
        "Everyone",
        "Everyone 10+",
        "Teen"
    ]
    //types filter
    static let gameTypes = [
        "Single-player",
        "Multi-player",
        "Co-op",
        "Online Co-op",
        "Local Co-op",
        "PvP",
        "Online PvP",
        "Local PvP",
        "Split Screen"
    ]
    //developers filter
    static let developers = [
        "Nintendo",
        "PlayStation Studios",
        "Xbox Game Studios",
        "Electronic Arts",
        "Ubisoft",
        "SEGA",
        "Square Enix",
        "Bandai Namco",
        "Activision",
        "Epic Games",
        "Capcom",
        "Bethesda"
    ]
    //star ratings filter
    static let starRatings = [
        "4.5+ Stars",
        "4+ Stars",
        "3.5+ Stars",
        "3+ Stars"
    ]
    //ordering filter
    static let ordering = [
        "Name",
        "Release Date",
        "Rating",
        "Metacritic Score"
    ]
}
