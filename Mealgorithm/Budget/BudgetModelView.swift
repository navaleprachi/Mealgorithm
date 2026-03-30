//
//  BudgetModelView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/23/25.
//

import Foundation
import CoreData
import SwiftUI

class BudgetModelView: ObservableObject {
    @Published var entries: [BudgetEntry] = []

    private let context = PersistenceController.shared.container.viewContext

    func saveEntry(amount: String, category: String, notes: String, month: String, date: Date) {
        guard let amountValue = Double(amount) else { return }

        let newEntry = BudgetEntry(context: context)
        newEntry.id = UUID()
        newEntry.amount = amountValue
        newEntry.category = category
        newEntry.notes = notes
        newEntry.date = date
        newEntry.month = month

        do {
            try context.save()
            fetchEntries()
        } catch {
            print("Failed to save entry:", error.localizedDescription)
        }
    }

    func fetchEntries() {
        let request: NSFetchRequest<BudgetEntry> = BudgetEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BudgetEntry.date, ascending: false)]

        do {
            entries = try context.fetch(request)
        } catch {
            print("Fetch error:", error.localizedDescription)
        }
    }
}

