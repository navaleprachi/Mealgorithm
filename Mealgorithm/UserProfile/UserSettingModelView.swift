//
//  UserSettingModelView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/25/25.
//

import SwiftUI
import UserNotifications

class UserSettingsViewModel: ObservableObject {
    @AppStorage("name") var name: String = ""
    @AppStorage("dietPreference") var dietPreference: String = "None"
    @AppStorage("mealGoal") var mealGoal: String = ""
    @AppStorage("email") var email: String = ""

    @Published var newName: String = ""
    @Published var newEmail: String = ""
    @Published var newPassword: String = ""

    func saveName() {
        if !newName.isEmpty {
            name = newName
        }
    }

    func saveEmail() {
        if !newEmail.isEmpty {
            email = newEmail
        }
    }

    func savePassword() {
        // Save to Keychain or your own mechanism
        print("Password Updated: \(newPassword)")
    }
    
    private func getReminderText(from reminder: UNNotificationRequest) -> String {
        if let trigger = reminder.trigger as? UNCalendarNotificationTrigger,
           let weekday = trigger.dateComponents.weekday,
           let hour = trigger.dateComponents.hour,
           let minute = trigger.dateComponents.minute {

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let day = formatter.weekdaySymbols[weekday - 1]

            let formattedTime = String(format: "%02d:%02d", hour, minute)

            return "Buy grocery on \(day) at \(formattedTime)"
        }
        return "Grocery Reminder"
    }
}

class NotificationHelper {
    static func fetchUpcomingGroceryReminders(completion: @escaping ([String]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let groceryReminders = requests
                .filter { $0.identifier.contains("grocery_reminder") }
                .map { request in
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                       let weekday = trigger.dateComponents.weekday {
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        let weekdayName = formatter.weekdaySymbols[weekday - 1]
                        return "Buy grocery on \(weekdayName) at 9:00 AM"
                    }
                    return "Unknown Reminder"
                }

            completion(groceryReminders)
        }
    }
}

