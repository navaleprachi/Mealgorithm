//
//  PersistenceController.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static let preview: PersistenceController = {
            let controller = PersistenceController(inMemory: true)
            return controller
        }()
    
//    static var preview: PersistenceController = {
//           let controller = PersistenceController(inMemory: true)
//
//           // Example: pre-populate preview data if needed
//           let viewContext = controller.container.viewContext
//           let demoUser = UserProfile(context: viewContext)
//           demoUser.name = "Prachi"
//           demoUser.dietPreference = "Vegan"
//           demoUser.mealGoal = "Eat Healthier"
//
//           do {
//               try viewContext.save()
//           } catch {
//               let nsError = error as NSError
//               fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//           }
//
//           return controller
//       }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }
}
