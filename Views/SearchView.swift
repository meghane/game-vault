//
//  SearchView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var showingFilter = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                //search bar with filter
                HStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .onChange(of: searchText) { oldValue, newValue in
                                Task {
                                    await viewModel.searchGames(query: newValue)
                                }
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                    )
                    
                    Button(action: {
                        showingFilter = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)
                
                //content area
                ScrollView {
                    if searchText.isEmpty {
                        Text("Search for games...")
                            .foregroundColor(.gray)
                            .padding()
                    } else if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else if let error = viewModel.error {
                        VStack(spacing: 8) {
                            Text("Error searching games")
                                .font(.headline)
                            Text(error.localizedDescription)
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        .padding()
                    } else if viewModel.searchResults.isEmpty {
                        Text("No games found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.searchResults) { game in
                                NavigationLink(destination: GameDetailView(gameId: game.id)) {
                                    SearchResultCard(game: game)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Search")
            .navigationDestination(isPresented: $showingFilter) {
                FilterView()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
