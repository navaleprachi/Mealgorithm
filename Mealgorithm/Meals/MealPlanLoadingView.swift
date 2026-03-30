//
//  MealPlanLoadingView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/20/25.
//

import SwiftUI
import CoreData

struct MealPlanLoadingView: View {
    @Binding var isCreatingPlan: Bool
    @EnvironmentObject var recipeVM: RecipeViewModel
    @EnvironmentObject var planModel: MealPlanModelView
    @FetchRequest(entity: UserProfile.entity(), sortDescriptors: [])
    var profiles: FetchedResults<UserProfile>

    @State private var navigateToBreakfast = false
    @State private var showError = false

    var userDiet: String {
        profiles.first?.dietPreference ?? "vegetarian"
    }

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.4),
                    Color.indigo.opacity(0.4)
                ],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ProgressView()
                    .scaleEffect(1.6)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))

                Text("Building your meal plan…")
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Text("Fetching recipes, balancing nutrition, and optimizing your choices.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if showError {
                    VStack(spacing: 8) {
                        Text("⚠️ No recipes found. Please check your internet or try again.")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            fetchAllRecipes()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    .padding(.top)
                }

                Spacer()
            }
        }
        .onAppear {
            fetchAllRecipes()
        }
        .navigationDestination(isPresented: $navigateToBreakfast) {
            BreakfastPlanView(
                fetchedRecipes: recipeVM.breakfastRecipes,
                isCreatingPlan: $isCreatingPlan
            )
            .environmentObject(recipeVM)
            .environmentObject(planModel)
        }
    }

    func fetchAllRecipes() {
        showError = false
        recipeVM.fetchRecipes(mealType: "breakfast", diet: userDiet) {
            if !recipeVM.breakfastRecipes.isEmpty {
                navigateToBreakfast = true
            } else {
                showError = true
            }
        }

        // Background fetches for lunch & dinner
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            recipeVM.fetchRecipes(mealType: "lunch", diet: userDiet)
            recipeVM.fetchRecipes(mealType: "dinner", diet: userDiet)
        }
    }
}

#Preview {
    NavigationStack {
        MealPlanLoadingView(isCreatingPlan: .constant(true))
            .environmentObject(RecipeViewModel())
            .environmentObject(MealPlanModelView())
    }
}
