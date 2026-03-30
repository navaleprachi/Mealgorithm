//
//  GroceryDayView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/25/25.
//

import SwiftUI
import UserNotifications

struct GroceryDayView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("groceryDay") private var groceryDay: String = "Sunday"
    @State private var showConfirmation = false

    @State private var selectedDay: String
    let daysOfWeek = Calendar.current.weekdaySymbols

    init() {
        _selectedDay = State(initialValue: UserDefaults.standard.string(forKey: "groceryDay") ?? "Sunday")
    }

    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            VStack(spacing: 80) {
                VStack(spacing: 12) {
                    Text("Choose Your Grocery Day")
                        .font(.title2.bold())
                        .padding(.top)

                    Text("We'll remind you on the selected day every week at 9 AM.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Picker("Grocery Day", selection: $selectedDay) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day).tag(day)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }

                Button(action: {
                    groceryDay = selectedDay
                    scheduleGroceryReminder(for: selectedDay)
                    showConfirmation = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                }) {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.indigo],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal)
            }
            .padding(.top, 40)
        }
        .navigationTitle("Grocery Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toast(isPresented: $showConfirmation, message: "Reminder saved successfully!")
    }

    // MARK: - Notification Logic
    func scheduleGroceryReminder(for day: String) {
        let content = UNMutableNotificationContent()
        content.title = "Grocery Day Reminder"
        content.body = "Don't forget your grocery shopping today!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.weekday = weekdayIndex(for: day)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "grocery_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Grocery reminder set for \(day) at 9 AM")
            }
        }
    }

    func weekdayIndex(for day: String) -> Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE"

        guard let date = formatter.date(from: day) else { return 1 }
        return Calendar.current.component(.weekday, from: date)
    }
}

// MARK: - Toast Extension
extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 2.0) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.subheadline)
                        .padding()
                        .background(Color.black.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isPresented.wrappedValue = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GroceryDayView()
}
