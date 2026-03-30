//
//  PlannedBudgetEntryView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/24/25.
//

import SwiftUI

struct PlannedBudgetEntryView: View {
    @ObservedObject var viewModel = PlannedBudgetModelView()

    @State private var selectedMonth = DateFormatter.monthOnly.string(from: Date())
    @State private var selectedCategory = "Groceries"
    @State private var amount = ""
    @State private var showToast = false

    let months = Calendar.current.monthSymbols
    let categories = ["Rent", "Groceries", "Dining", "Shopping", "Miscellaneous"]

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Title
                VStack(spacing: 8) {
                    Text("Planned Budget")
                        .font(.largeTitle.bold())
                        .padding(.top, 30)

                    Text("Set your expected budget for the month below.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Inputs
                VStack(spacing: 16) {
                    inputCard(title: "Month") {
                        Picker("Select Month", selection: $selectedMonth) {
                            ForEach(months, id: \.self) { month in
                                Text(month)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    inputCard(title: "Category") {
                        Picker("Select Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    inputCard(title: "Planned Amount") {
                        TextField("Enter amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Save Button
                Button(action: {
                    if let amt = Double(amount) {
                        viewModel.savePlannedBudget(category: selectedCategory, amount: amt, month: selectedMonth)
                        amount = ""
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showToast = false
                        }
                    }
                }) {
                    Text("Save Plan")
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
                .disabled(Double(amount) == nil)
                .padding(.bottom, 40)
            }
            .background(Color("AppBackground"))
            .ignoresSafeArea(edges: .bottom)

            // Confirmation Toast
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("✅ Planned budget saved!")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green.opacity(0.9))
                            )
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.4), value: showToast)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .hideKeyboardOnTap()
    }

    // MARK: - Custom Input Card
    @ViewBuilder
    func inputCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            content()
                .padding(12)
                .background(Color("CardBackground"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    PlannedBudgetEntryView()
}


