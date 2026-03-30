//
//  EmptyMealCard.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/22/25.
//

import SwiftUI

struct EmptyMealCard: View {
    var onCreatePlan: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.grid.2x2")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)

            Text("Get started")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Build a healthy and tasty meal plan")
                .foregroundColor(.gray)
                .font(.subheadline)

            Button(action: onCreatePlan) {
                Text("Create meal plan")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .padding(.horizontal)
    }
}

#Preview {
    EmptyMealCard {
        print("Tapped create plan")
    }
}
