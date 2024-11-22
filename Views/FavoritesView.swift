//
//  FavoritesView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

//structure of the favorites screen
struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if favoritesManager.favoriteGames.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "star")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No favorites yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    VStack(spacing: 16) {
                        ForEach(Array(favoritesManager.favoriteGames), id: \.self) { gameId in
                            FavoriteGameCard(gameId: gameId)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

// structure of the game card inside the favorites view
struct FavoriteGameCard: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @StateObject private var viewModel = GameDetailViewModel()
    let gameId: String
    
    var body: some View {
        NavigationLink(destination: GameDetailView(gameId: Int(gameId) ?? 0)) {
            HStack(spacing: 16) {
                // Game Image
                GameImageView(url: viewModel.gameDetails?.backgroundImage, width: 80, height: 80)
                
                // Game Info
                VStack(alignment: .leading, spacing: 4) {
                    if let name = viewModel.gameDetails?.name {
                        Text(name)
                            .font(.headline)
                    }
                    
                    if let rating = viewModel.gameDetails?.rating {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let released = viewModel.gameDetails?.released {
                        Text(released)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Favorite Button
                Button(action: {
                    favoritesManager.toggleFavorite(gameId: gameId)
                }) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .task {
            await viewModel.fetchGameDetails(gameId: Int(gameId) ?? 0)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesManager())
    }
}
