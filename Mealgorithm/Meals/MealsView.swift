//
//  MealsView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import SwiftUI
import CoreData

extension Int: @retroactive Identifiable {
    public var id: Int { self }
}

struct MealsView: View {
    @FetchRequest(
        entity: MealPlan.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MealPlan.startDate, ascending: false)],
        animation: .default
    ) private var mealPlans: FetchedResults<MealPlan>

    @State private var isCreatingPlan = false
    @State private var selectedTab: String = "Current"
    @State private var selectedRecipeId: Int?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.blue.opacity(0.3), location: 0),
                        .init(color: Color.clear, location: 0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: Header Title
                    HStack {
                        Text("Meal Plan")
                            .font(.largeTitle.bold())
                        Spacer()
                        
                        if selectedTab == "Current", let currentPlan = currentPlan {
                            Menu {
                                Button("Create new plan") { isCreatingPlan = true }
                                Button("Delete current plan", role: .destructive) {
                                    deleteMealPlan(currentPlan)
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // MARK: Tabs
                    if !mealPlans.isEmpty {
                        TabSwitcher(selectedTab: $selectedTab)
                            .padding(.top, 8)
                    }

                    // MARK: Main Content
                    if !mealPlans.isEmpty {
                        ScrollView {
                            VStack(spacing: 24) {
                                if selectedTab == "Current" {
                                    currentPlanSection
                                } else {
                                    pastPlansSection
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal)
                        }
                    } else {
                        EmptyMealCard {
                            isCreatingPlan = true
                        }
                        .padding(.top, 40)
                    }
                }
            }
            .background(Color("AppBackground").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            NavigationLink(
                destination: MealPlanDateSelectionView(isCreatingPlan: $isCreatingPlan),
                isActive: $isCreatingPlan
            ) {
                EmptyView()
            }
            .sheet(item: $selectedRecipeId) { id in
                RecipeDetailView(recipeId: id)
            }
        }
    }

    // MARK: - Computed Properties

    var currentPlan: MealPlan? {
        mealPlans.first(where: { ($0.endDate ?? Date()) >= Date() })
    }

    var pastPlans: [MealPlan] {
        mealPlans.filter { ($0.endDate ?? Date()) < Date() }
    }

    // MARK: - Current Plan Section

    var currentPlanSection: some View {
        Group {
            if let plan = currentPlan,
               let start = plan.startDate,
               let end = plan.endDate,
               let recipes = plan.recipesPerDate as? [String: [String: [String: Any]]] {

                let dates = generateDateRange(from: start, to: end)

                VStack(alignment: .leading, spacing: 24) {
                    ForEach(dates, id: \.self) { date in
                        let key = formattedKey(date)
                        if let meals = recipes[key] {
                            VStack(alignment: .leading, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(formattedDate(date))
                                        .font(.title3.bold())

                                    LinearGradient(
                                        colors: [Color.blue, Color.indigo],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 5)
                                    .cornerRadius(2)
                                    .padding(.trailing, 150)
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { type in
                                            if let dict = meals[type],
                                               let recipe = RecipeItem.fromDictionary(dict) {
                                                MealCard(mealType: type, recipe: recipe)
                                                    .onTapGesture {
                                                        selectedRecipeId = recipe.id
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    Text("No active meal plan.")
                        .font(.title3).bold()
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Past Plans Section

    var pastPlansSection: some View {
        Group {
            if pastPlans.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    Text("No past plans yet.")
                        .font(.title3).bold()
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 100)
                .frame(maxWidth: .infinity)
            } else {
                ForEach(pastPlans, id: \.self) { plan in
                    if let start = plan.startDate,
                       let end = plan.endDate,
                       let recipes = plan.recipesPerDate as? [String: [String: [String: Any]]] {

                        let dates = generateDateRange(from: start, to: end)

                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Plan: \(formattedDate(start)) - \(formattedDate(end))")
                                    .font(.headline)

                                LinearGradient(
                                    colors: [Color.blue, Color.indigo],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(height: 5)
                                .cornerRadius(2)
                                .padding(.trailing, 150)
                            }

                            ForEach(dates, id: \.self) { date in
                                let key = formattedKey(date)
                                if let meals = recipes[key] {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text(formattedDate(date))
                                            .font(.subheadline).bold()

                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 16) {
                                                ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { type in
                                                    if let dict = meals[type],
                                                       let recipe = RecipeItem.fromDictionary(dict) {
                                                        MealCard(mealType: type, recipe: recipe)
                                                            .onTapGesture {
                                                                selectedRecipeId = recipe.id
                                                            }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Divider()
                        }
                        .padding(.bottom, 12)
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    func generateDateRange(from start: Date, to end: Date) -> [Date] {
        var dates: [Date] = []
        var current = start
        while current <= end {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }

    func formattedKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func deleteMealPlan(_ plan: MealPlan) {
        let context = plan.managedObjectContext
        context?.delete(plan)
        try? context?.save()
    }
}


#Preview {
    MealsView()
}
