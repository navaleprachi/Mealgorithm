//
//  GroceryModelView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import Foundation
import CoreData
import UserNotifications

class GroceryModelView: ObservableObject {
    
    @Published var groceries: [GroceryItem] = []
    let context = PersistenceController.shared.container.viewContext
    
    func fetchGroceries() {
        let request: NSFetchRequest<GroceryItem> = GroceryItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GroceryItem.expiryDate, ascending: true)]

        do {
            groceries = try context.fetch(request)
        } catch {
            print("Failed to fetch groceries: \(error)")
        }
    }
    
    func addGrocery(
        name: String,
        quantity: Int,
        expiryDate: Date,
        category: String
    ) {
        let item = GroceryItem(context: context)
        item.id = UUID()
        item.name = name
        item.quantity = Int64(quantity)
        item.expiryDate = expiryDate
        item.category = category

        saveContext()
        scheduleExpiryNotification(for: item)
        fetchGroceries()
    }
    
    func updateGrocery(_ item: GroceryItem, name: String, quantity: Int, expiryDate: Date, category: String) {
        item.name = name
        item.quantity = Int64(quantity)
        item.expiryDate = expiryDate
        item.category = category

        saveContext()
        fetchGroceries()
    }

    func deleteGrocery(at offsets: IndexSet) {
        for index in offsets {
            let item = groceries[index]
            if let id = item.id {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
            }
            context.delete(item)
        }
        saveContext()
        fetchGroceries()
    }

    
    func scheduleExpiryNotification(for item: GroceryItem) {
        guard let expiry = item.expiryDate, let id = item.id else { return }

        let content = UNMutableNotificationContent()
        content.title = "🛒 \(item.name ?? "Item") is expiring soon"
        content.body = "Use it before \(expiry.formatted(date: .abbreviated, time: .omitted))!"
        content.sound = .default

        let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: expiry) ?? expiry
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        components.hour = 9 // 9 AM alert

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save grocery item: \(error)")
        }
    }
}
