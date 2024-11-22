//
//  Game.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import Foundation
import SwiftUI

//structures

struct GameResponse: Codable {
    let results: [Game]
    let count: Int
}

struct Rating: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}

struct Game: Codable, Identifiable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let metacritic: Int?
    let platforms: [PlatformContainer]
    
    var platformNames: [String] {
        platforms.map { $0.platform.name }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case metacritic
        case platforms
    }
}

//debugging extension
extension Game: CustomStringConvertible {
    var description: String {
        return """
        Game(
            id: \(id),
            name: \(name),
            backgroundImage: \(backgroundImage ?? "nil"),
            rating: \(rating)
        )
        """
    }
}

struct PlatformContainer: Codable {
    let platform: Platform
}

struct Platform: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Tag: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct ESRBRating: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Screenshot: Codable {
    let id: Int
    let image: String
}

struct GameDetails: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let released: String?
    let backgroundImage: String?
    let website: String?
    let rating: Double
    let platforms: [PlatformContainer]?
    let developers: [Developer]?
    let publishers: [Publisher]?
    let genres: [Genre]?
    let tags: [Tag]?
    let esrbRating: ESRBRating?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, released, website, rating
        case platforms, developers, publishers, genres, tags
        case backgroundImage = "background_image"
        case esrbRating = "esrb_rating"
    }
}

struct Developer: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Publisher: Codable {
    let id: Int
    let name: String
}

//extensions

extension Game {
    static var preview: Game {
        Game(
            id: 1,
            name: "Sample Game",
            released: "2023-01-01",
            backgroundImage: nil,
            rating: 4.5,
            metacritic: 85,
            platforms: [
                PlatformContainer(platform: Platform(id: 1, name: "PC", slug: "pc"))
            ]
        )
    }
}

extension GameDetails {
    static var preview: GameDetails {
        GameDetails(
            id: 1,
            name: "Sample Game",
            description: "This is a sample game description.",
            released: "2023-01-01",
            backgroundImage: nil,
            website: "https://example.com",
            rating: 4.5,
            platforms: [
                PlatformContainer(platform: Platform(id: 1, name: "PC", slug: "pc"))
            ],
            developers: [
                Developer(id: 1, name: "Sample Developer")
            ],
            publishers: [
                Publisher(id: 1, name: "Sample Publisher")
            ],
            genres: [
                Genre(id: 1, name: "Action", slug: "action")
            ],
            tags: [
                Tag(id: 1, name: "Singleplayer", slug: "singleplayer")
            ],
            esrbRating: ESRBRating(id: 1, name: "Everyone", slug: "everyone")
        )
    }
}
