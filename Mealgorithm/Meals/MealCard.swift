//
//  MealCard.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/23/25.
//

import SwiftUI

struct MealCard: View {
    let mealType: String
    let recipe: RecipeItem

    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(16, corners: [.topLeft, .topRight])

            // Meal Type
            Text(mealType.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.top, 8)

            // Title
            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)
                .padding(.horizontal, 12)

            Spacer()
        }
        .frame(width: 220, height: 260) // <- FIXED HEIGHT
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

// Helper extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 12.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


