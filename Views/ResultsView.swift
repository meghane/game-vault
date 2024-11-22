//
//  ResultsView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

struct ResultsView: View {
    @Environment(\.dismiss) private var dismiss
    let games: [Game]
    
    //layout
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(games) { game in
                    NavigationLink(destination: GameDetailView(gameId: game.id)) {
                        VStack(alignment: .leading) {
                            //image
                            GameImageView(url: game.backgroundImage, width: 150, height: 150)
                            
                            //game info
                            Text(game.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", game.rating))
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Results")
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ResultsView(games: [Game.preview])
    }
}
