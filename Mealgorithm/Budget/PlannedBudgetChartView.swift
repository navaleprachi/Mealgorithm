//
//  PlannedBudgetChartView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/24/25.
//

import SwiftUI
import Charts

struct BudgetComparison: Identifiable {
    let id = UUID()
    let category: String
    let planned: Double
    let actual: Double
    var status: String {
        actual > planned ? "Overspent" : "Underspent"
    }
}

struct PlannedBudgetChartView: View {
    @ObservedObject var viewModel: PlannedBudgetModelView
    let actualData: [String: Double]
    let selectedMonth: String
    @State private var animateBars = false

    var comparisonData: [BudgetComparison] {
        viewModel.plannedBudgetsForMonth(selectedMonth).map { item in
            let actualAmt = actualData[item.category ?? ""] ?? 0
            return BudgetComparison(
                category: item.category ?? "",
                planned: item.amount,
                actual: actualAmt
            )
        } + actualData.compactMap { (category, actualAmt) in
            guard !viewModel.plannedBudgets.contains(where: { $0.category == category && $0.month == selectedMonth }) else {
                return nil
            }
            return BudgetComparison(category: category, planned: 0, actual: actualAmt)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                if comparisonData.isEmpty {
                    // Empty planned state
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)

                        Text("No planned budgets yet")
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)

                        Text("Add a planned budget to start tracking!")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
                } else {
                    // Planned vs Actual Chart
                    Text("Planned vs Actual Spending")
                        .font(.title3)
                        .padding(.horizontal)

                    Chart {
                        ForEach(comparisonData) { item in
                            BarMark(
                                x: .value("Category", item.category),
                                y: .value("Planned", animateBars ? item.planned : 0)
                            )
                            .foregroundStyle(Color.blue)
                            .position(by: .value("Type", "Planned"))
                            .cornerRadius(4)

                            BarMark(
                                x: .value("Category", item.category),
                                y: .value("Actual", animateBars ? item.actual : 0)
                            )
                            .foregroundStyle(Color.green)
                            .position(by: .value("Type", "Actual"))
                            .cornerRadius(4)
                        }
                    }
                    .padding()
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 250)
                    .background(Color("CardBackground"))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .overlay(
                        // Inline Legend
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                                Text("Planned")
                                    .font(.caption2)
                                    .foregroundColor(.primary)
                            }
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                Text("Actual")
                                    .font(.caption2)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(8)
                        .background(Color("CardBackground").opacity(0.9))
                        .cornerRadius(8)
                        .padding(12)
                        , alignment: .topTrailing
                    )
                    .padding(.horizontal)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.2)) {
                            animateBars = true
                        }
                        viewModel.fetchPlannedBudgets()
                    }
                    
//                    HStack(spacing: 16) {
//                        HStack(spacing: 8) {
//                            Circle()
//                                .fill(Color.blue)
//                                .frame(width: 10, height: 10)
//                            Text("Planned")
//                                .font(.caption)
//                                .foregroundColor(.primary)
//                        }
//
//                        HStack(spacing: 8) {
//                            Circle()
//                                .fill(Color.green)
//                                .frame(width: 10, height: 10)
//                            Text("Actual")
//                                .font(.caption)
//                                .foregroundColor(.primary)
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 4)

                    Divider().padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Overspent Categories")
                                .font(.headline)
                        }
                        .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(comparisonData) { item in
                                PlannedBudgetCategoryCard(
                                    category: item.category,
                                    planned: item.planned,
                                    actual: item.actual,
                                    onEdit: {
                                        // Edit
                                    },
                                    onDelete: {
                                        // Delete
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.top)
        }
//        .background(Color("AppBackground").ignoresSafeArea())
    }
}


#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    // Create mock planned budgets
    let rent = PlannedBudget(context: context)
    rent.id = UUID()
    rent.category = "Rent"
    rent.amount = 500
    rent.month = "April"
    rent.createdAt = Date()
    
    let groceries = PlannedBudget(context: context)
    groceries.id = UUID()
    groceries.category = "Groceries"
    groceries.amount = 200
    groceries.month = "April"
    groceries.createdAt = Date()
    
    let model = PlannedBudgetModelView()
    model.plannedBudgets = [rent, groceries]
    
    let actuals: [String: Double] = [
        "Rent": 520,
        "Groceries": 180,
        "Dining": 150
    ]
    
    return PlannedBudgetChartView(
        viewModel: model,
        actualData: actuals,
        selectedMonth: "April"
    )
    .environment(\.managedObjectContext, context)
}


