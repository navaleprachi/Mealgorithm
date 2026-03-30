//
//  DietPrefencesEditView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/25/25.
//

import SwiftUI

struct DietPreferencesEditView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedPreference: String

    let dietOptions: [DietOption] = [
        .init(name: "Balanced", imageName: "blueberries"),
        .init(name: "Vegetarian", imageName: "vegetarian"),
        .init(name: "Vegan", imageName: "vegan"),
        .init(name: "Keto", imageName: "keto"),
        .init(name: "Low carb", imageName: "lowcarb"),
        .init(name: "Pescatarian", imageName: "pescatarian")
    ]

    init(viewModel: UserSettingsViewModel) {
        self.viewModel = viewModel
        _selectedPreference = State(initialValue: viewModel.dietPreference)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Diet Preference")
                .font(.title3)
//                .fontWeight(.semibold)
                .padding(.top)

            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                ForEach(dietOptions) { option in
                    Button(action: {
                        selectedPreference = option.name
                    }) {
                        VStack(spacing: 6) {
                            Image(option.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 80)
                                .clipped()
                                .cornerRadius(10)

                            Text(option.name)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(selectedPreference == option.name ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedPreference == option.name ? .white : .primary)
                        .cornerRadius(12)
                        .animation(.easeInOut, value: selectedPreference)
                    }
                }
            }
            .padding()

            Button("Save") {
                viewModel.dietPreference = selectedPreference
                dismiss()
            }
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
            .cornerRadius(12)
            .padding()
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationTitle("Diet Preference")
    }
}


#Preview {
    let viewModel = UserSettingsViewModel()
    DietPreferencesEditView(viewModel: viewModel)
}
