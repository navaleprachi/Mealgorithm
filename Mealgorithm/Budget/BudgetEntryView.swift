//
//  BudgetEntryView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/23/25.
//

import SwiftUI

struct BudgetEntryView: View {
    @ObservedObject var viewModel: BudgetModelView
    var onSave: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context

    @State private var selectedMonth = DateFormatter.monthOnly.string(from: Date())
    @State private var selectedCategory = "Groceries"
    @State private var amount = ""
    @State private var notes = ""

    @State private var showToast = false

    let months = Calendar.current.monthSymbols
    let categories = ["Rent", "Groceries", "Dining", "Shopping", "Miscellaneous"]

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    // Title
                    VStack(spacing: 8) {
                        Text("Add Budget Entry")
                            .font(.largeTitle.bold())
                            .padding(.top, 30)

                        Text("Track your expenses smartly by filling the details below.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Input Cards
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

                        inputCard(title: "Amount") {
                            TextField("Enter amount", text: $amount)
                                .keyboardType(.decimalPad)
                        }

                        inputCard(title: "Notes (Optional)") {
                            TextField("Add any notes", text: $notes)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Save Button
                    Button(action: {
                        viewModel.saveEntry(
                            amount: amount,
                            category: selectedCategory,
                            notes: notes,
                            month: selectedMonth,
                            date: Date()
                        )
                        onSave?()

                        // Show toast briefly
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    }) {
                        Text("Save Entry")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .padding(.horizontal)
                    }
                    .disabled(Double(amount) == nil)
                    .padding(.bottom, 20)
                }
                .background(Color("AppBackground"))
                .ignoresSafeArea(edges: .bottom)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        }
                    }
                }

                // Confirmation Toast
                if showToast {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("✅ Budget entry saved!")
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
            .hideKeyboardOnTap()
        }
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

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let monthOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let viewModel = BudgetModelView()
    return BudgetEntryView(viewModel: viewModel)
        .environment(\.managedObjectContext, context)
}

