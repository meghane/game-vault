//
//  GameImageView.swift
//  GameVault
//
//  Created by meghan on 11/21/24.
//

import SwiftUI

struct GameImageView: View {
    let url: String?
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        if let imageUrl = url {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                        )
                        .onAppear { print("⏳ Loading image from: \(imageUrl)") }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear { print("✅ Successfully loaded image from: \(imageUrl)") }
                case .failure(let error):
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            VStack {
                                Image(systemName: "gamecontroller")
                                    .foregroundColor(.gray)
                                Text(error.localizedDescription)
                                    .font(.system(size: 8))
                                    .foregroundColor(.red)
                            }
                        )
                        .onAppear { print("❌ Failed to load image: \(error.localizedDescription)") }
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
            }
            .frame(width: width, height: height)
            .clipped()
            .cornerRadius(8)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: width, height: height)
                .overlay(
                    Image(systemName: "gamecontroller")
                        .foregroundColor(.gray)
                )
                .cornerRadius(8)
                .onAppear { print("⚠️ No image URL provided") }
        }
    }
}
