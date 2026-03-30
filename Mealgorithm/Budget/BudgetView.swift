//
//  BudgetView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import SwiftUI

enum BudgetTabType: String, CaseIterable {
    case actual = "Actual"
    case planned = "Planned"
}

struct BudgetView: View {
    @Namespace private var namespace
    @StateObject private var actualModel = BudgetModelView()
    @StateObject private var plannedModel = PlannedBudgetModelView()
    @State private var showAddEntry = false
    @State private var selectedTab: BudgetTabType = .actual
    @State private var selectedMonth = DateFormatter.monthOnly.string(from: Date())
    @State private var shouldAnimatePie = false

    let months = Calendar.current.monthSymbols

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Fix 1: Gradient should fill whole background properly
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Fix 2: Title properly at top without extra top padding
                    HStack {
                        Text("Budget")
                            .font(.largeTitle.bold())
                        Spacer()
                        Button {
                            showAddEntry = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Month Selector
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 24) {
                                    ForEach(months, id: \.self) { month in
                                        VStack(spacing: 4) {
                                            Text(month)
                                                .font(.headline)
                                                .foregroundColor(
                                                    selectedMonth == month ? .primary : .gray
                                                )
                                                .onTapGesture {
                                                    withAnimation {
                                                        selectedMonth = month
                                                    }
                                                }
                                            if selectedMonth == month {
                                                Capsule()
                                                    .fill(Color.blue)
                                                    .frame(height: 3)
                                                    .matchedGeometryEffect(id: "underline", in: namespace)
                                            } else {
                                                Color.clear.frame(height: 3)
                                            }
                                        }
                                        .id(month)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top)
                            }
                            .onAppear {
                                actualModel.fetchEntries()
                                plannedModel.fetchPlannedBudgets()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    proxy.scrollTo(selectedMonth, anchor: .center)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    shouldAnimatePie = true
                                }
                            }
                        }

                        // Tab switcher
                        BudgetTabSwitcher(selectedTab: $selectedTab)
                                        .padding(.top, 10)
                        
                        // Actual/Planned view
                        if selectedTab == .actual {
                            ActualBudgetView(
                                viewModel: actualModel,
                                selectedMonth: selectedMonth,
                                animateTrigger: shouldAnimatePie
                            )
                        } else {
                            PlannedBudgetChartView(
                                viewModel: plannedModel,
                                actualData: getActualTotals(for: selectedMonth),
                                selectedMonth: selectedMonth
                            )
                        }
                    }
                }
                
            }
            .sheet(isPresented: $showAddEntry) {
                BudgetEntryView(viewModel: actualModel) {
                    actualModel.fetchEntries()
                }
            }
            .background(Color("AppBackground"))
        }
        
    }

    func getActualTotals(for month: String) -> [String: Double] {
        var totals: [String: Double] = [:]
        for entry in actualModel.entries where entry.month == month {
            let category = entry.category ?? "Other"
            totals[category, default: 0.0] += entry.amount
        }
        return totals
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return BudgetView()
        .environment(\.managedObjectContext, context)
}
