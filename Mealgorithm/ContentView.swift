//
//  ContentView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            GroceriesView()
            .tabItem {
                Label("Groceries", systemImage: "cart")
            }
            
       
            MealsView()
       
            .tabItem {
                Label("Meals", systemImage: "fork.knife")
            }

      
            BudgetView()
           
            .tabItem {
                Label("Budget", systemImage: "chart.bar")
            }

         
            RecipesView()
            
            .tabItem {
                Label("Recipes", systemImage: "book")
            }
            
            UserProfileView()
                .tabItem{
                    Label("User", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
