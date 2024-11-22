//
//  GameDetailView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

struct GameDetailView: View {
    let gameId: Int
    @StateObject private var viewModel = GameDetailViewModel()
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image
                if let backgroundImage = viewModel.gameDetails?.backgroundImage {
                    GameImageView(url: backgroundImage, width: UIScreen.main.bounds.width - 32, height: 200)
                }
                
                // Title and Rating
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.gameDetails?.name ?? "Loading...")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let rating = viewModel.gameDetails?.rating {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", rating))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Release Date
                if let released = viewModel.gameDetails?.released {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text("Released: \(released)")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Platforms
                if let platforms = viewModel.gameDetails?.platforms {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Available on:")
                            .font(.headline)
                        ForEach(platforms, id: \.platform.id) { platform in
                            Text("• \(platform.platform.name)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Description
                if let description = viewModel.gameDetails?.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                        Text(description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Developers
                if let developers = viewModel.gameDetails?.developers {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Developers")
                            .font(.headline)
                        ForEach(developers, id: \.id) { developer in
                            Text("• \(developer.name)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Website Link
                if let website = viewModel.gameDetails?.website,
                   let url = URL(string: website) {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Visit Website")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let gameId = viewModel.gameDetails?.id {
                    Button {
                        favoritesManager.toggleFavorite(gameId: String(gameId))
                    } label: {
                        Image(systemName: favoritesManager.isFavorite(gameId: String(gameId)) ? "star.fill" : "star")
                            .foregroundColor(favoritesManager.isFavorite(gameId: String(gameId)) ? .yellow : .gray)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchGameDetails(gameId: gameId)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            if let error = viewModel.error {
                Text(error.localizedDescription)
            }
        }
    }
}
