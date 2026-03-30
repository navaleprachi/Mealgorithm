//
//  RecipesView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import SwiftUI

struct RecipesView: View {
    @StateObject private var viewModel = AllRecipesViewModel()
    @State private var searchText = ""

    var filteredRecipes: [RecipeItem] {
        if searchText.isEmpty {
            return viewModel.recipes
        } else {
            return viewModel.recipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.indigo.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView("Fetching delicious recipes...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.2)
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(errorMessage: errorMessage)
                    } else if filteredRecipes.isEmpty {
                        emptyView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredRecipes.indices, id: \.self) { index in
                                RecipeCardView(recipe: filteredRecipes[index])
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                    .refreshable {
                        viewModel.fetchAllRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search recipes...")
            .onAppear {
                if viewModel.recipes.isEmpty {
                    viewModel.fetchAllRecipes()
                }
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)

            Text("No recipes found!")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Try a different keyword.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 100)
    }

    private func errorView(errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.orange)

            Text("Oops! Something went wrong.")
                .font(.title3)
                .fontWeight(.bold)

            Text(errorMessage)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                viewModel.fetchAllRecipes()
            }) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding(.top, 100)
    }
}

#Preview {
    RecipesView()
}
