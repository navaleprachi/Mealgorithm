//
//  AddGroceryView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import SwiftUI

struct AddGroceryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GroceryModelView

    @State private var name = ""
    @State private var quantity = 1
    @State private var expiryDate = Date()
    @State private var category = "Dairy"
    @State private var customCategory = ""

    var categories = ["Dairy", "Vegetables", "Snacks", "Fruits", "Beverages", "Custom"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Item Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("e.g., Milk", text: $name)
                            .padding()
                            .background(Color("CardBackground"))
                            .cornerRadius(12)
                    }
                    
                    // Quantity
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Quantity")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Stepper(value: $quantity, in: 1...99) {
                            Text("Quantity: \(quantity)")
                        }
                        .padding()
                        .background(Color("CardBackground"))
                        .cornerRadius(12)
                    }

                    // Expiry Date
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Expiry Date")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        DatePicker("Select Date", selection: $expiryDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding()
                            .background(Color("CardBackground"))
                            .cornerRadius(12)
                    }

                    // Category
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        // Capsule style picker buttons
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)]) {
                            ForEach(categories, id: \.self) { cat in
                                Button(action: {
                                    category = cat
                                }) {
                                    Text(cat)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(category == cat ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(category == cat ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                            }
                        }

                        if category == "Custom" {
                            TextField("Enter custom category", text: $customCategory)
                                .padding()
                                .background(Color("CardBackground"))
                                .cornerRadius(12)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .background(Color("AppBackground").ignoresSafeArea())
            .navigationTitle("Add Grocery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            // Add Button as full-width bottom button
            .safeAreaInset(edge: .bottom) {
                Button {
                    let finalCategory = category == "Custom" ? customCategory : category
                    viewModel.addGrocery(
                        name: name,
                        quantity: quantity,
                        expiryDate: expiryDate,
                        category: finalCategory
                    )
                    dismiss()
                } label: {
                    Text("Add Item")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
                .padding(.bottom, 12)
                .disabled(name.isEmpty || (category == "Custom" && customCategory.isEmpty))
            }
            .hideKeyboardOnTap()
        }
    }
}

#Preview {
    AddGroceryView(viewModel: GroceryModelView())
}

