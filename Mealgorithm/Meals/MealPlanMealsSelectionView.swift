import SwiftUI

struct MealPlanMealsSelectionView: View {
    let startDate: Date
    let endDate: Date
    @Binding var isCreatingPlan: Bool

    let mealTypes = ["Breakfast", "Lunch", "Dinner"]
    @State private var selectedMeals: [Date: Set<String>] = [:]
    @State private var showValidationAlert = false
    @StateObject var planModel = MealPlanModelView()
    @StateObject private var recipeVM = RecipeViewModel()
    @State private var navigateToLoading = false

    var allDates: [Date] {
        var dates: [Date] = []
        var current = startDate
        while current <= endDate {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    var body: some View {
        VStack(spacing: 0) {
            // Gradient header
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
            .frame(height: 220)
            .overlay(
                VStack(spacing: 4) {
                    Text("Select meals for each day")
                        .font(.title.bold())
                    Text("Choose Breakfast, Lunch, Dinner by tapping below.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 32)
            )

            // Grid
            ScrollView {
                VStack(spacing: 0) {
                    // Header row
                    HStack {
                        Text("Date")
                            .fontWeight(.semibold)
                            .frame(width: 100, alignment: .leading)
                        ForEach(mealTypes, id: \.self) { meal in
                            Text(meal)
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Divider().padding(.top)

                    // Grid rows
                    ForEach(allDates, id: \.self) { date in
                        HStack(alignment: .center) {
                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                .frame(width: 100, alignment: .leading)

                            ForEach(mealTypes, id: \.self) { meal in
                                let isSelected = selectedMeals[date, default: []].contains(meal)
                                MealTypeToggleButton(
                                    meal: meal,
                                    isSelected: isSelected
                                ) {
                                    toggleMeal(for: date, meal: meal)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }

            // Create Button
            Button(action: {
                if selectedMeals.keys.count < 3 {
                    showValidationAlert = true
                    return
                }
                planModel.startDate = startDate
                planModel.endDate = endDate
                planModel.selectedMeals = selectedMeals
                navigateToLoading = true
            }) {
                Text("Create Meal Plan")
                    .fontWeight(.semibold)
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
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
            .padding(.top)
            .padding(.bottom, 12)

            NavigationLink(
                destination: MealPlanLoadingView(isCreatingPlan: $isCreatingPlan)
                    .environmentObject(recipeVM)
                    .environmentObject(planModel),
                isActive: $navigateToLoading
            ) {
                EmptyView()
            }
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .alert("Please select meals for at least 3 different days.", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        }
    }

    func toggleMeal(for date: Date, meal: String) {
        var meals = selectedMeals[date, default: []]
        if meals.contains(meal) {
            meals.remove(meal)
        } else {
            meals.insert(meal)
        }
        selectedMeals[date] = meals
    }
}

struct MealTypeToggleButton: View {
    let meal: String
    let isSelected: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            Text(isSelected ? "✓" : "")
                .frame(width: 28, height: 28)
                .background(
                    isSelected
                    ? AnyShapeStyle(
                        LinearGradient(
                            colors: [Color.blue, Color.indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    : AnyShapeStyle(Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .white : .clear)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    NavigationStack {
        MealPlanMealsSelectionView(
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 6, to: Date())!,
            isCreatingPlan: .constant(true)
        )
    }
}

