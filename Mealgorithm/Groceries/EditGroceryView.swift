//
//  EditGroceryView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/16/25.
//

import SwiftUI

struct EditGroceryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GroceryModelView

    @State var item: GroceryItem

    @State private var name: String
    @State private var quantity: Int
    @State private var expiryDate: Date
    @State private var category: String
    @State private var customCategory: String

    let categories = ["Dairy", "Vegetables", "Snacks", "Fruits", "Beverages", "Custom"]

    init(viewModel: GroceryModelView, item: GroceryItem) {
        self.viewModel = viewModel
        _item = State(initialValue: item)
        _name = State(initialValue: item.name ?? "")
        _quantity = State(initialValue: Int(item.quantity))
        _expiryDate = State(initialValue: item.expiryDate ?? Date())
        let initialCategory = item.category ?? "Other"
        _category = State(initialValue: categories.contains(initialCategory) ? initialCategory : "Custom")
        _customCategory = State(initialValue: categories.contains(initialCategory) ? "" : initialCategory)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Name Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Item Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        TextField("e.g., Cheese", text: $name)
                            .padding()
                            .background(Color("CardBackground"))
                            .cornerRadius(12)
                    }
                    
                    // Quantity Stepper
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

                    // Expiry Date Picker
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

                    // Category Selector
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

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
            .navigationTitle("Edit Grocery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    item.name = name
                    item.quantity = Int64(quantity)
                    item.expiryDate = expiryDate
                    item.category = category == "Custom" ? customCategory : category

                    viewModel.updateGrocery(
                        item,
                        name: name,
                        quantity: quantity,
                        expiryDate: expiryDate,
                        category: category == "Custom" ? customCategory : category
                    )
                    dismiss()
                } label: {
                    Text("Update Item")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
                .padding(.bottom, 12)
                .disabled(!hasChanges || name.isEmpty || (category == "Custom" && customCategory.isEmpty))
            }
            .hideKeyboardOnTap()
        }
    }

    var hasChanges: Bool {
        let currentCategory = category == "Custom" ? customCategory : category
        return name != (item.name ?? "") ||
            quantity != item.quantity ||
            expiryDate != (item.expiryDate ?? Date()) ||
            currentCategory != (item.category ?? "")
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let sampleItem = GroceryItem(context: context)
    sampleItem.id = UUID()
    sampleItem.name = "Milk"
    sampleItem.quantity = 2
    sampleItem.expiryDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())
    sampleItem.category = "Dairy"
    
    return EditGroceryView(viewModel: GroceryModelView(), item: sampleItem)
}

