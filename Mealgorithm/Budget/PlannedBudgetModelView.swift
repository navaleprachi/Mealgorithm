//
//  PlannedBudgetModelView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/24/25.
//

import Foundation
import CoreData
import SwiftUI

class PlannedBudgetModelView: ObservableObject {
    @Published var plannedBudgets: [PlannedBudget] = []

    let context = PersistenceController.shared.container.viewContext

    func savePlannedBudget(category: String, amount: Double, month: String) {
        let newBudget = PlannedBudget(context: context)
        newBudget.id = UUID()
        newBudget.category = category
        newBudget.amount = amount
        newBudget.month = month
        newBudget.createdAt = Date()

        do {
            try context.save()
            fetchPlannedBudgets()
        } catch {
            print("Failed to save planned budget:", error.localizedDescription)
        }
    }

    func fetchPlannedBudgets() {
        let request: NSFetchRequest<PlannedBudget> = PlannedBudget.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PlannedBudget.createdAt, ascending: false)]

        do {
            plannedBudgets = try context.fetch(request)
        } catch {
            print("Failed to fetch planned budgets:", error.localizedDescription)
        }
    }

    func getPlannedAmount(for category: String, in month: String) -> Double {
        plannedBudgets.first(where: { $0.category == category && $0.month == month })?.amount ?? 0
    }

    func plannedBudgetsForMonth(_ month: String) -> [PlannedBudget] {
        plannedBudgets.filter { $0.month == month }
    }

    func deletePlannedBudget(_ budget: PlannedBudget) {
        context.delete(budget)
        try? context.save()
        fetchPlannedBudgets()
    }
}

