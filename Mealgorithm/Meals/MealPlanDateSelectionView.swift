//
//  MealPlanDateSelectionView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/18/25.
//

import SwiftUI

struct MealPlanDateSelectionView: View {
    @Binding var isCreatingPlan: Bool

    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date()
    @State private var navigateNext = false
    @State private var isPressed = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                .frame(height: 250)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // MARK: Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Let's get started")
                                .font(.largeTitle.bold())
                            Text("When would you like to start your meal plan?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)

                        // MARK: Info Text
                        Text("We'll create a 7-day meal plan.\nYou can adjust the start or end date.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)

                        // MARK: Date Pickers
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Start Date")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: $startDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .background(Color("CardBackground"))
                                    .cornerRadius(12)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("End Date")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .background(Color("CardBackground"))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 50)
                    }
                }
            }
            .background(Color("AppBackground").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)

            // MARK: Next Button
            .safeAreaInset(edge: .bottom) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        isPressed = false
                        navigateNext = true
                    }
                } label: {
                    Text("Next")
                        .fontWeight(.semibold)
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
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                }
                .padding(.bottom, 12)
            }

            NavigationLink(
                destination: MealPlanMealsSelectionView(
                    startDate: startDate,
                    endDate: endDate,
                    isCreatingPlan: $isCreatingPlan
                ),
                isActive: $navigateNext
            ) {
                EmptyView()
            }
        }
    }
}

#Preview {
    MealPlanDateSelectionView(
        isCreatingPlan: .constant(true)
    )
}

