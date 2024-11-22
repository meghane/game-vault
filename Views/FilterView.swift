//
//  FilterView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//
import SwiftUI


struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FilterViewModel()
    
    @State private var selectedGenres: Set<String> = []
    @State private var selectedPlatforms: Set<String> = []
    @State private var selectedTags: Set<String> = []
    @State private var selectedRatings: Set<String> = []
    @State private var selectedGameTypes: Set<String> = []
    @State private var selectedStarRating: String = "4+ Stars"
    @State private var selectedOrdering: String = "Rating"
    
    @State private var isGenreExpanded = false
    @State private var isPlatformExpanded = false
    @State private var isTagsExpanded = false
    @State private var isRatingExpanded = false
    @State private var isGameTypeExpanded = false
    @State private var isStarRatingExpanded = false
    @State private var isOrderingExpanded = false
    @State private var showingResults = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Genres Section
                VStack(alignment: .leading, spacing: 12) {
                    DisclosureGroup(
                        isExpanded: $isGenreExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(FilterOptions.genres, id: \.self) { genre in
                                    CheckboxRow(
                                        title: genre,
                                        isSelected: selectedGenres.contains(genre),
                                        action: {
                                            if selectedGenres.contains(genre) {
                                                selectedGenres.remove(genre)
                                            } else {
                                                selectedGenres.insert(genre)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        },
                        label: {
                            Text("Genres")
                                .font(.headline)
                        }
                    )
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Platforms Section
                VStack(alignment: .leading, spacing: 12) {
                    DisclosureGroup(
                        isExpanded: $isPlatformExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(FilterOptions.platforms, id: \.self) { platform in
                                    CheckboxRow(
                                        title: platform,
                                        isSelected: selectedPlatforms.contains(platform),
                                        action: {
                                            if selectedPlatforms.contains(platform) {
                                                selectedPlatforms.remove(platform)
                                            } else {
                                                selectedPlatforms.insert(platform)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        },
                        label: {
                            Text("Platforms")
                                .font(.headline)
                        }
                    )
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Tags Section
                VStack(alignment: .leading, spacing: 12) {
                    DisclosureGroup(
                        isExpanded: $isTagsExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(FilterOptions.tags, id: \.self) { tag in
                                    CheckboxRow(
                                        title: tag,
                                        isSelected: selectedTags.contains(tag),
                                        action: {
                                            if selectedTags.contains(tag) {
                                                selectedTags.remove(tag)
                                            } else {
                                                selectedTags.insert(tag)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        },
                        label: {
                            Text("Features")
                                .font(.headline)
                        }
                    )
                    .padding(.horizontal)
                }
                
                Divider()
                
                // ESRB Ratings Section
                VStack(alignment: .leading, spacing: 12) {
                    DisclosureGroup(
                        isExpanded: $isRatingExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(FilterOptions.esrbRatings, id: \.self) { rating in
                                    CheckboxRow(
                                        title: rating,
                                        isSelected: selectedRatings.contains(rating),
                                        action: {
                                            if selectedRatings.contains(rating) {
                                                selectedRatings.remove(rating)
                                            } else {
                                                selectedRatings.insert(rating)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        },
                        label: {
                            Text("ESRB Rating")
                                .font(.headline)
                        }
                    )
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Game Type Section
                VStack(alignment: .leading, spacing: 12) {
                    DisclosureGroup(
                        isExpanded: $isGameTypeExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(FilterOptions.gameTypes, id: \.self) { type in
                                    CheckboxRow(
                                        title: type,
                                        isSelected: selectedGameTypes.contains(type),
                                        action: {
                                            if selectedGameTypes.contains(type) {
                                                selectedGameTypes.remove(type)
                                            } else {
                                                selectedGameTypes.insert(type)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        },
                        label: {
                            Text("Game Type")
                                .font(.headline)
                        }
                    )
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Star Rating Section
                VStack(alignment: .leading, spacing: 12) {
                    DisclosureGroup(
                        isExpanded: $isStarRatingExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(FilterOptions.starRatings, id: \.self) { rating in
                                    RadioRow(
                                        title: rating,
                                        isSelected: selectedStarRating == rating,
                                        action: {
                                            selectedStarRating = rating
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        },
                        label: {
                            Text("Minimum Rating")
                                .font(.headline)
                        }
                    )
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Sort By Section
                VStack(alignment: .leading, spacing: 12) {
                    DisclosureGroup(
                        isExpanded: $isOrderingExpanded,
                        content: {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(FilterOptions.ordering, id: \.self) { order in
                                    RadioRow(
                                        title: order,
                                        isSelected: selectedOrdering == order,
                                        action: {
                                            selectedOrdering = order
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        },
                        label: {
                            Text("Sort By")
                                .font(.headline)
                        }
                    )
                    .padding(.horizontal)
                }
                
                // Show Results Button
                Button(action: {
                    Task {
                        await viewModel.applyFilters(
                            genres: selectedGenres,
                            platforms: selectedPlatforms,
                            tags: selectedTags,
                            ratings: selectedRatings,
                            gameTypes: selectedGameTypes,
                            starRating: selectedStarRating,
                            ordering: selectedOrdering
                        )
                        showingResults = true
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Show Results")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black)
                .cornerRadius(8)
                .padding()
                .padding(.top, 20)
                .disabled(viewModel.isLoading)
            }
        }
        .navigationTitle("Filter")
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            }
        }
        .fullScreenCover(isPresented: $showingResults) {
            NavigationStack {
                ResultsView(games: viewModel.filteredGames)
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

struct CheckboxRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .black : .gray)
                Text(title)
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}

struct RadioRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "circle.fill" : "circle")
                    .foregroundColor(isSelected ? .black : .gray)
                Text(title)
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}

