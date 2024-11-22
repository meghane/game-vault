//
//  GameCard.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

struct GameCard: View {
    let game: Game
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                //game image
                GameImageView(url: game.backgroundImage, width: 150, height: 150)
                
                //game info
                VStack(alignment: .leading, spacing: 4) {
                    if let firstPlatform = game.platformNames.first {
                        Text(firstPlatform)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(game.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", game.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .frame(width: 150)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
//preview for the game card
struct GameCard_Previews: PreviewProvider {
    static var previews: some View {
        //using sample game
        let sampleGame = Game(
            id: 3498,  //GTA V's ID
            name: "Grand Theft Auto V",
            released: "2013-09-17",
            backgroundImage: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
            rating: 4.5,
            metacritic: 92,
            platforms: [
                PlatformContainer(platform: Platform(id: 1, name: "PC", slug: "pc"))
            ]
        )
        
        Group {
            //light mode
            GameCard(game: sampleGame, onTap: {})
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Light Mode")
            
            //dark mode
            GameCard(game: sampleGame, onTap: {})
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            //loading state
            GameCard(game: Game(
                id: 1,
                name: "Sample Game",
                released: "2023-01-01",
                backgroundImage: nil,
                metacritic: 85,
                platforms: [
                    PlatformContainer(platform: Platform(id: 1, name: "PC", slug: "pc"))
                ]
            ), onTap: {})
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Loading State")
        }
    }
}
