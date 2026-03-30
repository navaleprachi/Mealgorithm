//
//  ActualBudgetView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/24/25.
//

//
//  ActualBudgetView.swift
//  Mealgorithm
//

import SwiftUI
import CoreData

struct ActualBudgetView: View {
    @ObservedObject var viewModel: BudgetModelView
    var selectedMonth: String
    var animateTrigger: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                if filteredEntriesByMonth().isEmpty {
                    // Empty state
                    VStack(spacing: 12) {
                        Image(systemName: "tray.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        
                        Text("No budget entries yet")
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)
                        
                        Text("Tap '+' above to add your first entry!")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
                    
                } else {
                    // Spending Breakdown Section
                    Text("Spending Breakdown")
                        .font(.title3)
                        .padding(.horizontal)

                    GeometryReader { geo in
                        PieChartView(
                            animateTrigger: animateTrigger,
                            data: getPieChartData(),
                            title: ""
                        )
                        .frame(width: geo.size.width)
                        .frame(height: 250)
                        .background(Color("CardBackground"))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    }
                    .frame(height: 250)
                    .padding(.horizontal)

                    Divider().padding(.horizontal)

                    // Categories Section
                    Text("Categories")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        ForEach(filteredEntriesByMonth(), id: \.id) { entry in
                            BudgetCategoryCard(
                                category: entry.category ?? "Other",
                                amount: entry.amount,
                                onEdit: {
                                    // Open edit
                                },
                                onDelete: {
                                    // Handle delete
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top)
            .onAppear {
                viewModel.fetchEntries()
            }
        }
//        .background(Color("AppBackground").ignoresSafeArea())
    }

    // MARK: - Helpers

    func filteredEntriesByMonth() -> [BudgetEntry] {
        viewModel.entries.filter { $0.month == selectedMonth }
    }

    func getPieChartData() -> [String: Double] {
        var totals: [String: Double] = [:]
        for entry in filteredEntriesByMonth() {
            let category = entry.category ?? "Other"
            totals[category, default: 0.0] += entry.amount
        }
        return totals
    }
}


// MARK: - Preview
#Preview {
    let context = PersistenceController.preview.container.viewContext

    class MockBudgetModelView: BudgetModelView {
        init(context: NSManagedObjectContext) {
            super.init()
            
            let entry1 = BudgetEntry(context: context)
            entry1.id = UUID()
            entry1.amount = 120
            entry1.category = "Groceries"
            entry1.month = "April"
            entry1.date = Date()

            let entry2 = BudgetEntry(context: context)
            entry2.id = UUID()
            entry2.amount = 250
            entry2.category = "Rent"
            entry2.month = "April"
            entry2.date = Date()

            self.entries = [entry1, entry2]
        }
    }

    return ActualBudgetView(
        viewModel: MockBudgetModelView(context: context),
        selectedMonth: "April",
        animateTrigger: true
    )
    .environment(\.managedObjectContext, context)
}


