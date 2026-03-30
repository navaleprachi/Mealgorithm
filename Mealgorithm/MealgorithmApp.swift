//
//  MealgorithmApp.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/14/25.
//

import SwiftUI
import UserNotifications
import CoreData

@main
struct MealgorithmApp: App {
    
    let context = PersistenceController.shared.container.viewContext
    
    init(){
        requestNotificationPermission()
//        resetCoreData(context: context)
//        UserDefaults.standard.set(false, forKey: "isLoggedIn")
//        UserDefaults.standard.set(false, forKey: "didCompleteSetup")
    }
    
    var body: some Scene {
        WindowGroup {
            EntryPointView()
                .environment(\.managedObjectContext, context)
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied or error: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    func resetCoreData(context: NSManagedObjectContext) {
        guard let coordinator = context.persistentStoreCoordinator else { return }

        for entity in coordinator.managedObjectModel.entities {
            if let name = entity.name {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try context.execute(deleteRequest)
                } catch {
                    print("Failed to delete \(name): \(error)")
                }
            }
        }

        do {
            try context.save()
            print("All CoreData entities wiped.")
        } catch {
            print("Error saving context after reset: \(error)")
        }
    }

}
