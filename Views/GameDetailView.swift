//
//  FilterView.swift
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
                //header image
                if let backgroundImage = viewModel.gameDetails?.backgroundImage {
                    GameImageView(url: backgroundImage, width: UIScreen.main.bounds.width - 32, height: 200)
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
                        Text("Released: \(formatDate(released))")
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
                    HStack {
                        Button {
                            favoritesManager.toggleFavorite(gameId: String(gameId))
                        } label: {
                            Image(systemName: favoritesManager.isFavorite(gameId: String(gameId)) ? "bookmark.fill" : "bookmark")
                                .foregroundColor(favoritesManager.isFavorite(gameId: String(gameId)) ? .black : .black)
                        }
                        
                        // Share button
                        Button(action: {
                            shareGameInfo()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.black)
                        }
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
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //input format
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MM-dd-yyyy" //output format
            return dateFormatter.string(from: date)
        }
        return dateString //return original if parsing fails
    }
    
    private func shareGameInfo() {
        guard let gameDetails = viewModel.gameDetails else { return }
        
        let shareText = """
        Check out this game: \(gameDetails.name)
        Rating: \(String(format: "%.1f", gameDetails.rating))
        Description: \(gameDetails.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
        """
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // Present the activity view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }
}


