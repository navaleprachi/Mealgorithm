//
//  RecipeCardView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/26/25.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: RecipeItem
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(16)

                LinearGradient(
                    colors: [.black.opacity(0.6), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 80)
                .cornerRadius(16)

                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
            }
        }
        .background(Color("CardBackground"))
        .cornerRadius(16)
        .shadow(radius: 4)
        .onTapGesture {
            showDetail = true
        }
        .fullScreenCover(isPresented: $showDetail) {
            RecipeDetailView(recipeId: recipe.id)
        }
    }
}

