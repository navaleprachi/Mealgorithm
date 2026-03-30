//
//  RecipeViewModel.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/21/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var breakfastRecipes: [RecipeItem] = []
    @Published var lunchRecipes: [RecipeItem] = []
    @Published var dinnerRecipes: [RecipeItem] = []

    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    @Published var hasFetchedBreakfast = false
    @Published var hasFetchedLunch = false
    @Published var hasFetchedDinner = false

    func fetchRecipes(mealType: String, diet: String, completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil

        RecipeAPIService.shared.fetchRecipes(mealType: mealType, diet: diet) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let recipes):
                    switch mealType {
                    case "breakfast": self.breakfastRecipes = recipes
                    case "lunch": self.lunchRecipes = recipes
                    case "dinner": self.dinnerRecipes = recipes
                    default: break
                    }
                    completion?()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion?()
                }
            }
        }
    }

    func swapOptionsFor(mealType: String, excluding ids: Set<Int>) -> [RecipeItem] {
        let source: [RecipeItem]
        switch mealType {
        case "breakfast": source = breakfastRecipes
        case "lunch": source = lunchRecipes
        case "dinner": source = dinnerRecipes
        default: source = []
        }
        return source.filter { !ids.contains($0.id) }.prefix(5).map { $0 }
    }

    func assignRecipesToDates(selectedMeals: [Date: Set<String>]) -> [String: [String: RecipeItem]] {
            var result: [String: [String: RecipeItem]] = [:]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            for (date, mealTypes) in selectedMeals {
                var meals: [String: RecipeItem] = [:]
                for mealType in mealTypes {
                    let pool: [RecipeItem]
                    switch mealType.lowercased() {
                    case "breakfast": pool = breakfastRecipes
                    case "lunch": pool = lunchRecipes
                    case "dinner": pool = dinnerRecipes
                    default: pool = []
                    }
                    if let recipe = pool.randomElement() {
                        meals[mealType] = recipe
                    }
                }
                result[formatter.string(from: date)] = meals
            }
            return result
        }
}
