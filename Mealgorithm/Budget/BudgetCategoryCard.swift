//
//  BudgetCategoryCard.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/24/25.
//
//
//  BudgetCategoryCard.swift
//  Mealgorithm
//

import SwiftUI

struct BudgetCategoryCard: View {
    let category: String
    let amount: Double
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

                Text("$\(amount, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Menu {
                    Button("Edit", systemImage: "pencil", action: onEdit)
                    Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
            }

            ProgressView(value: min(amount / 500, 1.0))
                .progressViewStyle(LinearProgressViewStyle(tint: categoryColor))
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
    BudgetCategoryCard(category: "Groceries", amount: 180,
                       onEdit: { print("Edit Groceries") },
                       onDelete: { print("Delete Groceries") })
        .padding()
        .background(Color(.systemGroupedBackground))
}

