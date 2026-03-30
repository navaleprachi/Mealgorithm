//
//  EditEmailView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/25/25.
//

import SwiftUI

struct EditEmailView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showConfirmation = false

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()

            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Update Your Email")
                        .font(.title2.bold())

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Current Email")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(viewModel.email)
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color("CardBackground"))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("New Email")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        TextField("Enter new email", text: $viewModel.newEmail)
                            .padding()
                            .background(Color("CardBackground"))
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                    }
                }

                Spacer()

                Button(action: {
                    viewModel.saveEmail()
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
                .disabled(viewModel.newEmail.isEmpty)
            }
            .padding()
            .navigationTitle("Edit Email")
            .navigationBarTitleDisplayMode(.inline)

            if showConfirmation {
                VStack {
                    Spacer()
                    Text("Email updated successfully!")
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
    viewModel.email = "xyz@gmail.com"
    viewModel.newEmail = ""

    return NavigationStack {
        EditEmailView(viewModel: viewModel)
    }
}
