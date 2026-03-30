//
//  EditNameView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/25/25.
//

import SwiftUI

struct EditNameView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showConfirmation = false

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()

            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Update Your Name")
                        .font(.title2.bold())

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Current Name")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(viewModel.name)
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color("CardBackground"))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("New Name")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        TextField("Enter new name", text: $viewModel.newName)
                            .padding()
                            .background(Color("CardBackground"))
                            .cornerRadius(10)
                    }
                }

                Spacer()

                Button(action: {
                    viewModel.saveName()
                    showConfirmation = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }) {
                    Text("Save")
                        .bold()
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
                }
                .disabled(viewModel.newName.isEmpty)
            }
            .padding()
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)

            // Confirmation Toast
            if showConfirmation {
                VStack {
                    Spacer()
                    Text("Name updated successfully!")
                        .font(.subheadline)
                        .padding()
                        .background(Color.black.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showConfirmation = false
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    let viewModel = UserSettingsViewModel()
    viewModel.name = "Prachi"
    viewModel.newName = ""
    return NavigationStack {
        EditNameView(viewModel: viewModel)
    }
}


