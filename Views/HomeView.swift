//
//  HomeView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedGameId: Int?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    //home section
                    Text("Home")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    //trending carousel
                    VStack(alignment: .leading) {
                        Text("Trending")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.games) { game in
                                        GameCard(game: game) {
                                            selectedGameId = game.id
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    //recommended carousel
                    VStack(alignment: .leading) {
                        Text("Recommended")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.games) { game in
                                        GameCard(game: game) {
                                            selectedGameId = game.id
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchGames()
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedGameId != nil },
                set: { if !$0 { selectedGameId = nil } }
            )) {
                if let gameId = selectedGameId {
                    GameDetailView(gameId: gameId)
                }
            }
        }
    }
}

//separate view for the card content
struct GameCardContent: View {
    let game: Game
    
    var body: some View {
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
}
