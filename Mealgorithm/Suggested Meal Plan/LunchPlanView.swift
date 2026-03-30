//
//  LunchPlanView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/20/25.
//

import SwiftUI

struct LunchPlanView: View {
    @State var fetchedRecipes: [RecipeItem]
    @State private var swapOptions: [RecipeItem] = []
    @Binding var isCreatingPlan: Bool

    @State private var selectedRecipe: RecipeItem? = nil
    @State private var showSwapSheet = false
    @State private var navigateToDinner = false
    @EnvironmentObject var recipeVM: RecipeViewModel
    @EnvironmentObject var planModel: MealPlanModelView
    
    @State private var selectedRecipeIndex: Int? = nil

    var userDiet: String {
        UserDefaults.standard.string(forKey: "dietPreference") ?? "vegetarian"
    }

    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    var lunchDates: [Date] {
        planModel.selectedMeals
            .filter { $0.value.contains("Lunch") }
            .map { $0.key }
            .sorted()
    }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 10) {
                // Header section
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        progressStep(icon: "sunrise.fill", label: "Breakfast", isCurrent: false)
                        progressStep(icon: "fork.knife", label: "Lunch", isCurrent: true)
                        progressStep(icon: "moon.fill", label: "Dinner", isCurrent: false)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Review lunch")
                            .font(.title2.bold())

                        Text("We've picked lunch recipes for your plan. Tap Swap to personalize!")
                            .font(.footnote)
                            .foregroundColor(.gray.opacity(0.9))
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 40)

                VStack(spacing: 0) {
                    ScrollView {
                        Spacer(minLength: 16)

                        VStack(spacing: 16) {
                            ForEach(Array(lunchDates.enumerated()), id: \.1) { index, date in
                                let recipe = fetchedRecipes[index % fetchedRecipes.count]
                                let formattedDate = date.formatted(date: .abbreviated, time: .omitted)

                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: recipe.image)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(formattedDate.uppercased())
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.gray.opacity(0.4))
                                            .clipShape(Capsule())

                                        Text(recipe.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)

                                        Label("AI-picked", systemImage: "sparkles")
                                            .font(.caption2)
                                            .foregroundColor(.blue)
                                    }

                                    Spacer()

                                    VStack {
                                        Text("Swap")
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        Button {
                                            selectedRecipeIndex = index
                                            let shownIDs = Set(fetchedRecipes.map { $0.id })
                                            swapOptions = recipeVM.swapOptionsFor(mealType: "lunch", excluding: shownIDs)
                                            showSwapSheet = true
                                        } label: {
                                            Image(systemName: "arrow.left.arrow.right")
                                                .padding(10)
                                                .background(Circle().fill(LinearGradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)], startPoint: .top, endPoint: .bottom)))
                                        }
                                    }
                                }
                                .padding()
                                .background(Color("CardBackground"))
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 24)
                    }

                    NavigationLink(
                        isActive: $navigateToDinner,
                        destination: {
                            DinnerPlanView(
                                fetchedRecipes: recipeVM.dinnerRecipes,
                                isCreatingPlan: $isCreatingPlan
                            )
                            .environmentObject(recipeVM)
                            .environmentObject(planModel)
                        },
                        label: {
                            EmptyView()
                        }
                    )

                    Spacer()

                    Button("Next") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"

                        for (index, date) in lunchDates.enumerated() {
                            let recipe = fetchedRecipes[index % fetchedRecipes.count]
                            let dateKey = formatter.string(from: date)

                            var dayMeals = planModel.recipesPerDate[dateKey] ?? [:]
                            dayMeals["Lunch"] = recipe
                            planModel.recipesPerDate[dateKey] = dayMeals
                        }

                        navigateToDinner = true
                    }
                    .font(.headline)
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
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSwapSheet) {
            if let index = selectedRecipeIndex {
                RecipeSwapSheetView(
                    swapOptions: recipeVM.lunchRecipes,
                    onSwap: { swapped in
                        if index < fetchedRecipes.count {
                            fetchedRecipes[index] = swapped
                        }
                        showSwapSheet = false
                    },
                    onDismiss: {
                        showSwapSheet = false
                    }
                )
            }
        }
    }

    @ViewBuilder
    func progressStep(icon: String, label: String, isCurrent: Bool) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .padding(12)
                .background(Circle().fill(isCurrent ? Color.white.opacity(0.2) : Color.white.opacity(0.05)))
                .overlay(Circle().stroke(isCurrent ? Color.white : Color.clear, lineWidth: 2))

            Text(label)
                .font(.caption)
                .opacity(isCurrent ? 1 : 0.7)
        }
        .frame(width: 70)
    }
}


#Preview {
    LunchPlanView(
        fetchedRecipes: [
            RecipeItem(id: 10, title: "Grilled Veggie Wrap", image: "https://spoonacular.com/recipeImages/10-312x231.jpg"),
            RecipeItem(id: 11, title: "Quinoa Salad", image: "https://spoonacular.com/recipeImages/11-312x231.jpg"),
            RecipeItem(id: 12, title: "Chickpea Bowl", image: "https://spoonacular.com/recipeImages/12-312x231.jpg")
        ],
        isCreatingPlan: .constant(true)
    )
    .environmentObject(RecipeViewModel())
    .environmentObject(MealPlanModelView())
}
