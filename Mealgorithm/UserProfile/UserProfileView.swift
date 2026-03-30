//
//  UserProfileView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/24/25.
//

import SwiftUI
import UserNotifications

struct UserProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @StateObject var settingsVM = UserSettingsViewModel()
    @State private var upcomingReminders: [String] = []
    @AppStorage("groceryDay") private var groceryDay: String = "Sunday"
    @State private var pendingNotifications: [UNNotificationRequest] = []
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Title
                        VStack(spacing: 6) {
                            Text("Settings")
                                .font(.largeTitle.bold())
                                .padding(.top, 24)

                            Text("Manage your preferences and account")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)

                        // Sections
                        VStack(spacing: 16) {
                            sectionCard(title: "Diet", items: [
                                SettingItem(title: "Diet Preferences", icon: "fork.knife.circle", destination: DietPreferencesEditView(viewModel: settingsVM))
                            ])

                            sectionCard(title: "Meal Plan", items: [
                                SettingItem(title: "Grocery Day", icon: "cart.circle", destination: GroceryDayView()),
                                SettingItem(title: "Budget Plan", icon: "dollarsign.circle", destination: PlannedBudgetEntryView())
                            ])

                            if !upcomingReminders.isEmpty {
                                sectionCard(title: "Reminders", items: upcomingReminders.map { reminder in
                                    SettingItem(title: reminder, icon: "bell.fill", isReminder: true)
                                }, isReminderSection: true)
                            }

                            sectionCard(title: "Account",items: [
                                SettingItem(title: "Name",icon: "person.circle",destination: EditNameView(viewModel: settingsVM)),
                                                                 
                                SettingItem(title: "Change Email", icon: "envelope.circle", destination: EditEmailView(viewModel: settingsVM)),
                                                                 
                                SettingItem(title: "Change Password", icon: "lock.circle", destination: EditPasswordView(viewModel: settingsVM)),
                                                                 
                                SettingItem(title: "Sign Out", icon: "rectangle.portrait.and.arrow.right", isSignOut: true)
                            ]
)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }

                if showDeleteConfirmation {
                    VStack {
                        Spacer()
                        Text("Reminder Deleted!")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(20)
                            .padding(.bottom, 40)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut, value: showDeleteConfirmation)
                    }
                }
            }
            .onAppear {
                fetchReminders()
            }
            .onChange(of: groceryDay) { _ in
                fetchReminders()
            }
        }
    }

    // MARK: - Section Card
    @ViewBuilder
    func sectionCard(title: String, items: [SettingItem], isReminderSection: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                ForEach(items) { item in
                    if let destination = item.destination {
                        NavigationLink(destination: destination().toolbar(.hidden, for: .tabBar)) {
                            settingRow(item: item)
                        }
                    } else {
                        settingRow(item: item)
                            .onTapGesture {
                                if item.isSignOut {
                                    withAnimation {
                                        isLoggedIn = false
                                    }
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                if item.isReminderSection {
                                    Button(role: .destructive) {
                                        deleteReminder(named: item.title)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                    }
                }
            }
            .padding()
            .background(Color("CardBackground"))
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Setting Row
    @ViewBuilder
    func settingRow(item: SettingItem) -> some View {
        HStack {
            Label(item.title, systemImage: item.icon)
                .font(.body)
                .foregroundColor(item.isSignOut ? .red : .primary)

            Spacer()

            if !item.isReminder {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .imageScale(.small)
            }
        }
    }

    // MARK: - Delete Reminder by Name
    private func deleteReminder(named title: String) {
        let id = "grocery_reminder_\(title)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

        fetchReminders()
        withAnimation {
            showDeleteConfirmation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showDeleteConfirmation = false
            }
        }
    }

    // MARK: - Fetch Reminders
    private func fetchReminders() {
        NotificationHelper.fetchUpcomingGroceryReminders { reminders in
            DispatchQueue.main.async {
                self.upcomingReminders = reminders
            }
        }
    }
}

// MARK: - SettingItem Model
struct SettingItem: Identifiable {
    var id = UUID()
    let title: String
    let icon: String
    var destination: (() -> AnyView)? = nil
    var isSignOut: Bool = false
    var isReminder: Bool = false
    var isReminderSection: Bool = false

    init<V: View>(
        title: String,
        icon: String,
        destination: V? = nil,
        isSignOut: Bool = false,
        isReminder: Bool = false,
        isReminderSection: Bool = false
    ) {
        self.title = title
        self.icon = icon
        if let view = destination {
            self.destination = { AnyView(view) }
        }
        self.isSignOut = isSignOut
        self.isReminder = isReminder
        self.isReminderSection = isReminderSection
    }

    // Fallback init for items without a destination (like reminders)
    init(
        title: String,
        icon: String,
        isSignOut: Bool = false,
        isReminder: Bool = false,
        isReminderSection: Bool = false
    ) {
        self.title = title
        self.icon = icon
        self.destination = nil
        self.isSignOut = isSignOut
        self.isReminder = isReminder
        self.isReminderSection = isReminderSection
    }
}

#Preview {
    UserProfileView()
}
