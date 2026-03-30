//
//  PlannedBudgetCategoryCard.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/24/25.
//

//
//  PlannedBudgetCategoryCard.swift
//  Mealgorithm
//

import SwiftUI

struct PlannedBudgetCategoryCard: View {
    let category: String
    let planned: Double
    let actual: Double
    var onEdit: () -> Void
    var onDelete: () -> Void

    var categoryColor: Color {
        switch category.lowercased() {
        case "rent": return .blue
        case "groceries": return .green
        case "dining": return .orange
        case "shopping": return .purple
        case "miscellaneous": return .pink
        default: return .gray
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(category, systemImage: icon(for: category))
                    .font(.headline)
                    .foregroundColor(categoryColor)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Planned: $\(planned, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("Actual: $\(actual, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(actual > planned ? .red : .green)
                }

                Menu {
                    Button("Edit", systemImage: "pencil", action: onEdit)
                    Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
            }

            ProgressView(value: min(actual / planned, 1.0))
                .progressViewStyle(LinearProgressViewStyle(tint: actual > planned ? .red : .green))
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }

    func icon(for category: String) -> String {
        switch category.lowercased() {
        case "rent": return "house.fill"
        case "groceries": return "cart.fill"
        case "dining": return "fork.knife"
        case "shopping": return "bag.fill"
        case "miscellaneous": return "ellipsis"
        default: return "creditcard"
        }
    }
}


#Preview {
    VStack(spacing: 20) {
        PlannedBudgetCategoryCard(
            category: "Groceries",
            planned: 200,
            actual: 180,
            onEdit: { print("Edit Groceries") },
            onDelete: { print("Delete Groceries") }
        )
        PlannedBudgetCategoryCard(
            category: "Dining",
            planned: 150,
            actual: 170,
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

