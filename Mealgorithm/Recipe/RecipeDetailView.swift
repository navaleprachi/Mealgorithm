//
//  RecipeDetailView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/23/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipeId: Int
    @State private var recipe: RecipeDetail?
    @State private var isLoading = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading recipe...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            } else if let recipe = recipe {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        GeometryReader { geo in
                            AsyncImage(url: URL(string: recipe.image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(5)
                                    .frame(width: geo.size.width, height: 280)
                                    .clipped()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                                    .frame(width: geo.size.width, height: 280)
                            }
                            .overlay(alignment: .topLeading) {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(.top, 10)
                                .padding(.leading, 16)
                            }
                        }
                        .frame(height: 280)

                        // Title + Time + Servings
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            HStack {
                                Label("\(recipe.readyInMinutes) mins", systemImage: "clock")
                                Spacer()
                                Label("\(recipe.servings) servings", systemImage: "person.2")
                                    .multilineTextAlignment(.trailing)
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }

                        Divider()

                        // Ingredients Section
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Ingredients", systemImage: "list.bullet")
                                .font(.headline)
                                .foregroundColor(.blue)

                            ForEach(recipe.extendedIngredients, id: \.id) { ingredient in
                                Text("• \(ingredient.original)")
                                    .font(.body)
                            }
                        }

                        Divider()

                        // Instructions Section
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Instructions", systemImage: "text.justify")
                                .font(.headline)
                                .foregroundColor(.blue)

                            if let steps = extractSteps(from: recipe.instructions) {
                                ForEach(steps.indices, id: \.self) { index in
                                    Text("\(index + 1). \(steps[index])")
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                }
                            } else {
                                Text("No instructions provided.")
                                    .foregroundColor(.gray)
                            }
                        }

                        Spacer(minLength: 30)
                    }
                    .padding()
                }
                .background(Color("AppBackground").ignoresSafeArea())
                .transition(.move(edge: .bottom))
            } else {
                VStack {
                    Text("Failed to load recipe")
                        .foregroundColor(.red)
                    Button("Close") {
                        dismiss()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchRecipeDetail()
        }
    }

    // MARK: - Fetch & Format Helpers

    func fetchRecipeDetail() {
        RecipeAPIService.shared.fetchRecipeDetails(recipeId: recipeId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.recipe = detail
                case .failure:
                    self.recipe = nil
                }
                self.isLoading = false
            }
        }
    }

    func extractSteps(from html: String?) -> [String]? {
        guard let html = html else { return nil }
        return html
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .components(separatedBy: CharacterSet(charactersIn: ".•\n"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}

#Preview {
    RecipeDetailView(recipeId: 716429)
}

