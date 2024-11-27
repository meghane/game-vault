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
                                    // Add delay to avoid too many API calls
                                    try? await Task.sleep(nanoseconds: 500_000_000)
                                    await viewModel.searchGames(query: newValue)
                                }
                            }
                            .autocorrectionDisabled()
                            .submitLabel(.search)
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
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            Text("Search for games...")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    } else if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 100)
                    } else if let error = viewModel.error {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                                .padding()
                            Text("Error searching games")
                                .font(.headline)
                            Text(error.localizedDescription)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 100)
                    } else if viewModel.searchResults.isEmpty {
                        VStack {
                            Image(systemName: "magnifyingglass.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            Text("No games found")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
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
