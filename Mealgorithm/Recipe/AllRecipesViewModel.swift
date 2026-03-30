//
//  AllRecipesViewModel.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/26/25.
//

import Foundation

class AllRecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchAllRecipes() {
        isLoading = true
        errorMessage = nil

        var urlComponents = URLComponents(string: "https://api.spoonacular.com/recipes/complexSearch")!
        urlComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: Secrets.spoonacularAPIKey),
            URLQueryItem(name: "number", value: "100") // Fetch 100 recipes
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let response = try JSONDecoder().decode(RecipeResult.self, from: data)
                    self.recipes = response.results
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}

