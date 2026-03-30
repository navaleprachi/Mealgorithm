//
//  BasicInfoView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/18/25.
//

import SwiftUI

struct DietOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct BasicInfoView: View {
    let context = PersistenceController.shared.container.viewContext

    @AppStorage("name") private var name: String = ""
    @AppStorage("dietPreference") private var dietPreference: String = "None"
    @AppStorage("mealGoal") private var mealGoal: String = ""
    @AppStorage("didCompleteSetup") private var didCompleteSetup: Bool = false

    @State private var currentPage = 0
    @Namespace private var animation

    let dietOptions: [DietOption] = [
        .init(name: "Balanced", imageName: "blueberries"),
        .init(name: "Vegetarian", imageName: "vegetarian"),
        .init(name: "Vegan", imageName: "vegan"),
        .init(name: "Keto", imageName: "keto"),
        .init(name: "Low carb", imageName: "lowcarb"),
        .init(name: "Pescatarian", imageName: "pescatarian")
    ]

    let goalOptions = ["Eat Healthier", "Save Money", "Reduce Stress"]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(
                    colors: [Color.blue.opacity(0.2), Color.indigo.opacity(0.2)]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // Progress Dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Capsule()
                            .fill(
                                index <= currentPage ? Color.indigo : Color.gray
                                    .opacity(0.3)
                            )
                            .frame(width: index == currentPage ? 30 : 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.top, 24)

                TabView(selection: $currentPage) {
                    // STEP 1: Name
                    VStack(spacing: 24) {
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.indigo)

                        Text("What should we call you?")
                            .font(.title2.bold())

                        TextField("Enter your name", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)

                        Spacer()

                        Button("Next") {
                            withAnimation { currentPage = 1 }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .tag(0)

                    // STEP 2: Diet Preference
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)

                        Text("Do you follow a specific diet?")
                            .font(.title2.bold())

                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                            ForEach(dietOptions) { option in
                                Button {
                                    dietPreference = option.name
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(option.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 80)
                                            .cornerRadius(10)

                                        Text(option.name)
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(
                                        dietPreference == option.name ? Color.indigo : Color(
                                            .systemGray6
                                        )
                                    )
                                    .foregroundColor(dietPreference == option.name ? .white : .primary)
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)

                        Spacer()

                        Button("Next") {
                            withAnimation { currentPage = 2 }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .tag(1)

                    // STEP 3: Meal Goal
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "target")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.purple)

                        Text("What’s your current meal goal?")
                            .font(.title2.bold())

                        VStack(spacing: 16) {
                            ForEach(goalOptions, id: \.self) { goal in
                                Button {
                                    mealGoal = goal
                                } label: {
                                    Text(goal)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            mealGoal == goal ? Color.indigo : Color(
                                                .systemGray6
                                            )
                                        )
                                        .foregroundColor(mealGoal == goal ? .white : .primary)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)

                        Spacer()

                        Button {
                            let profile = UserProfile(context: context)
                            profile.name = name
                            profile.dietPreference = dietPreference
                            profile.mealGoal = mealGoal
                            try? context.save()

                            withAnimation {
                                didCompleteSetup = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Let’s Start")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
            }
        }
        .hideKeyboardOnTap()
    }
}

#Preview {
    BasicInfoView()
}

