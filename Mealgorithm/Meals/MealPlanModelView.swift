//
//  MealPlanModelView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/20/25.
//

import Foundation
import CoreData

class MealPlanModelView: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedMeals: [Date: Set<String>] = [:]
    @Published var recipesPerDate: [String: [String: RecipeItem]] = [:]

    func saveMealPlan(startDate: Date,
                      endDate: Date,
                      selectedMeals: [Date: Set<String>],
                      recipesPerDate: [String: [String: RecipeItem]]) {
        
        let mealPlan = MealPlan(context: context)
        mealPlan.id = UUID()
        mealPlan.startDate = startDate
        mealPlan.endDate = endDate

        // Save meals per day
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var mealsDict: [String: [String]] = [:]
        for (date, meals) in selectedMeals {
            mealsDict[formatter.string(from: date)] = Array(meals)
        }
        mealPlan.mealsPerDay = mealsDict as NSObject

        // Save selected recipes per date/meal
        mealPlan.recipesPerDate = encodeRecipesPerDate(recipesPerDate)

        do {
            try context.save()
            print("Meal plan with grouped recipes saved.")
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }
    }

    private func encodeRecipesPerDate(_ data: [String: [String: RecipeItem]]) -> NSObject {
        let transformed: [String: [String: [String: Any]]] = data.mapValues { mealMap in
            mealMap.mapValues { $0.asDictionary() }
        }
        return transformed as NSDictionary
    }
}

