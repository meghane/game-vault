//
//  GameDetailView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI
import AVKit

struct GameDetailView: View {
    let gameId: Int
    @StateObject private var viewModel = GameDetailViewModel()
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showTrailer = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //header image with trailer button
                if let backgroundImage = viewModel.gameDetails?.backgroundImage {
                    ZStack {
                        GameImageView(url: backgroundImage, width: UIScreen.main.bounds.width - 32, height: 200)
                        
                        if viewModel.trailerUrl != nil {
                            Button(action: {
                                showTrailer = true
                            }) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                }
                
                //title and rating
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
                
                //release date
                if let released = viewModel.gameDetails?.released {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text("Released: \(released)")
                            .foregroundColor(.secondary)
                    }
                }
                
                //platforms
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
                
                //description
                if let description = viewModel.gameDetails?.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                        Text(description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
                            .foregroundColor(.secondary)
                    }
                }
                
                //developers
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
                
                //website link
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
        .sheet(isPresented: $showTrailer) {
            if let trailerUrl = viewModel.trailerUrl,
               let url = URL(string: trailerUrl) {
                TrailerView(trailerUrl: url)
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

// Add this new view for the trailer
struct TrailerView: View {
    let trailerUrl: URL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VideoPlayer(player: AVPlayer(url: trailerUrl))
                .ignoresSafeArea()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
