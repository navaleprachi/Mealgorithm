//
//  RecipeSwapSheet.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/21/25.
//

import SwiftUI

struct RecipeSwapSheetView: View {
    let swapOptions: [RecipeItem]
    let onSwap: (RecipeItem) -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Curated Suggestions")
                .font(.headline)
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(swapOptions) { recipe in
                        VStack(alignment: .leading) {
                            ZStack(alignment: .topTrailing) {
                                AsyncImage(url: URL(string: recipe.image)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                                Button {
                                    onSwap(recipe)
                                } label: {
                                    Image(systemName: "arrow.left.arrow.right")
                                        .foregroundColor(.blue)
                                        .padding(8)
                                        .background(Circle().fill(Color.white))
                                }
                                .offset(x: -10, y: 10)
                            }

                            Text(recipe.title)
                                .font(.caption)
                                .lineLimit(2)
                                .frame(width: 150, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Button("Done") {
                onDismiss()
            }
            .font(.body.bold())
            .padding(.bottom)
        }
        .presentationDetents([.fraction(0.5)])
    }
}

#Preview {
    RecipeSwapSheetView(
        swapOptions: [
            RecipeItem(id: 1, title: "Avocado Toast", image: "https://spoonacular.com/recipeImages/1-312x231.jpg"),
            RecipeItem(id: 2, title: "Greek Yogurt Bowl", image: "https://spoonacular.com/recipeImages/2-312x231.jpg")
        ],
        onSwap: { _ in },
        onDismiss: {}
    )
}
