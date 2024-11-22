//
//  SearchResultsCard.swift
//  GameVault
//
//  Created by meghan on 11/21/24.
//

import SwiftUI

struct SearchResultCard: View {
    let game: Game
    
    var body: some View {
        HStack(spacing: 12) {
            //game image
            if let backgroundImage = game.backgroundImage {
                AsyncImage(url: URL(string: backgroundImage)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            //game info
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    Text(String(format: "%.1f", game.rating))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                if let released = game.released {
                    Text(released)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            //arrow indicator
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct SearchResultCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultCard(game: Game.preview)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
