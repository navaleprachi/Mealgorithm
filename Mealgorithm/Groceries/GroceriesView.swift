//
//  GroceriesView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import SwiftUI
import UserNotifications

struct GroceriesView: View {
    @StateObject private var viewModel = GroceryModelView()
    @State private var showAddSheet = false
    @State private var searchGrocery = ""
    @State private var editingItem: GroceryItem? = nil
    @State private var selectedFilter = "All"
    
    let filterIcons: [String: String] = [
        "All": "filterAllIcon",
        "Expiring Soon": "expiringSoonIcon",
        "Expired": "expiredIcon",
        "Dairy": "dairyIcon",
        "Vegetables": "vegetablesIcon",
        "Fruits": "fruitIcon",
        "Snacks": "snackIcon",
        "Beverages": "beveragesIcon",
        "Other": "otherIcon"
    ]

    var filteredGroceries: [GroceryItem] {
        let base = viewModel.groceries.filter {
            searchGrocery.isEmpty || ($0.name?.localizedCaseInsensitiveContains(searchGrocery) == true)
        }
        
        switch selectedFilter {
        case "Expiring Soon":
            return base.filter {
                guard let date = $0.expiryDate else { return false }
                let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? Int.max
                return daysLeft >= 0 && daysLeft <= 2
            }
        case "Expired":
            return base.filter {
                guard let date = $0.expiryDate else { return false }
                return date < Date()
            }
        case "All":
            return base
        default:
            return base.filter { $0.category == selectedFilter }
        }
    }
    
    var categorizedGroceries: [String: [GroceryItem]] {
        Dictionary(grouping: filteredGroceries) { $0.category ?? "Uncategorized" }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .top)
                .frame(height: 220)
                
                VStack(spacing: 5) {
                    // MARK: - Custom Header
                    HStack {
                        Text("Groceries")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button {
                            showAddSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal)
                    
                    // MARK: - Search Bar
                    TextField("Search groceries...", text: $searchGrocery)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .padding(.top, 4)

                    // MARK: - Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            filterButton("All")
                            filterButton("Expiring Soon")
                            filterButton("Expired")
                            ForEach(Array(Set(viewModel.groceries.compactMap { $0.category })).sorted(), id: \.self) { category in
                                filterButton(category)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    
                    // MARK: - Content
                    if categorizedGroceries.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "cart.badge.plus")
                                .font(.system(size: 64))
                                .foregroundStyle(.secondary)
                            Text("No Groceries Yet!")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Tap '+' to add your first grocery item.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(categorizedGroceries.keys.sorted(), id: \.self) { category in
                                Section(header:
                                    Text(category)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                ) {
                                    ForEach(categorizedGroceries[category] ?? [], id: \.self) { item in
                                        GroceryRow(item: item)
                                            .listRowSeparator(.hidden)
                                            .listRowBackground(Color.clear)
                                            .transition(.opacity)
                                            .swipeActions(edge: .trailing) {
                                                Button(role: .destructive) {
                                                    if let index = categorizedGroceries[category]?.firstIndex(of: item) {
                                                        deleteItems(from: categorizedGroceries[category] ?? [], at: IndexSet(integer: index))
                                                    }
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    editingItem = item
                                                } label: {
                                                    Label("Edit", systemImage: "pencil")
                                                }
                                                .tint(.blue)
                                            }
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                .padding(.top, 8)
            }
            .sheet(isPresented: $showAddSheet) {
                AddGroceryView(viewModel: viewModel)
            }
            .sheet(item: $editingItem) { item in
                EditGroceryView(viewModel: viewModel, item: item)
            }
            .onAppear {
                viewModel.fetchGroceries()
            }
            .background(Color("AppBackground").ignoresSafeArea())
            .hideKeyboardOnTap()
        }
    }

    // MARK: - Filter Chip
    @ViewBuilder
    func filterButton(_ label: String) -> some View {
        let isSelected = selectedFilter == label
        let categoryColors: [String: Color] = [
            "Dairy": .blue,
            "Vegetables": .green,
            "Fruits": .red,
            "Snacks": .orange,
            "Beverages": .purple,
            "Other": .gray,
            "All": .black,
            "Expired": .red,
            "Expiring Soon": .yellow
        ]

        Button(action: {
            withAnimation {
                selectedFilter = label
            }
        }) {
            HStack(spacing: 6) {
                if let iconName = filterIcons[label] {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding(5)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                Text(label)
                    .font(.subheadline)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                Capsule()
                    .fill(isSelected ? categoryColors[label, default: .blue] : Color.gray.opacity(0.15))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .animation(.easeInOut(duration: 0.25), value: selectedFilter)
        }
    }

    func deleteItems(from source: [GroceryItem], at offsets: IndexSet) {
        let itemsToDelete = offsets.map { source[$0] }
        for item in itemsToDelete {
            if let id = item.id {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
            }
            viewModel.context.delete(item)
        }
        viewModel.saveContext()
        viewModel.fetchGroceries()
    }
}


//MARK: - Header Background
struct HeaderBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.teal.opacity(0.3), Color.clear]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(edges: .top)
        .frame(height: 150)
    }
}


//MARK: - Grocery card

struct GroceryRow: View {
    let item: GroceryItem
    let categoryIcons: [String: String] = [
        "Dairy": "dairyIcon",
        "Vegetables": "vegetablesIcon",
        "Fruits": "fruitIcon",
        "Snacks": "snackIcon",
        "Beverages": "beveragesIcon",
        "Other": "archivebox"
    ]

    let categoryColors: [String: Color] = [
        "Dairy": .blue,
        "Vegetables": .green,
        "Fruits": .red,
        "Snacks": .orange,
        "Beverages": .purple,
        "Other": .gray
    ]
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            if let category = item.category, let iconName = categoryIcons[category] {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                // Row 1: Name + Expiry Date
                HStack {
                    Text(item.name ?? "")
                        .font(.headline)
                    
                    Spacer()
                    
                    if let expiry = item.expiryDate {
                        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: expiry).day ?? 0
                        Text("Expires: \(expiry.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(daysLeft < 0 ? .red : daysLeft <= 2 ? .orange : .gray)
                    }
                }
                
                // Row 2: Qty + Status badge
                if let expiry = item.expiryDate {
                    let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: expiry).day ?? 0
                    HStack {
                        Text("Quantity: \(item.quantity)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        StatusBadge(label: statusText(for: daysLeft), color: statusColor(for: daysLeft))
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(statusColor(for: daysLeft).opacity(0.2))
                            )
                            .foregroundColor(statusColor(for: daysLeft))
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.vertical, 4)
    }
    
    func statusText(for daysLeft: Int) -> String {
        if daysLeft < 0 { return "Expired" }
        else if daysLeft == 0 { return "Today" }
        else if daysLeft == 1 { return "Tomorrow" }
        else if daysLeft <= 2 { return "Soon" }
        else { return "Fresh" }
    }
    
    func statusColor(for daysLeft: Int) -> Color {
        if daysLeft < 0 { return .red }
        else if daysLeft <= 1 { return .orange }
        else { return .green }
    }
}


struct StatusBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color.opacity(0.1))
                    .overlay(
                        Capsule()
                            .strokeBorder(color.opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(color)
    }
}


#Preview {
    GroceriesView()
}
