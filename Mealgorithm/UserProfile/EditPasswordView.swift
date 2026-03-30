//
//  EditPasswordView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/25/25.
//

import SwiftUI

struct EditPasswordView: View {
    @ObservedObject var viewModel: UserSettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showConfirmation = false

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()

            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Update Your Password")
                        .font(.title2.bold())

                    VStack(alignment: .leading, spacing: 6) {
                        Text("New Password")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        SecureField("Enter new password", text: $viewModel.newPassword)
                            .padding()
                            .background(Color("CardBackground"))
                            .cornerRadius(10)
                    }
                }

                Spacer()

                Button(action: {
                    viewModel.savePassword()
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
                .disabled(viewModel.newPassword.isEmpty)
            }
            .padding()
            .navigationTitle("Edit Password")
            .navigationBarTitleDisplayMode(.inline)

            if showConfirmation {
                VStack {
                    Spacer()
                    Text("Password updated successfully!")
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
    viewModel.newPassword = ""

    return NavigationStack {
        EditPasswordView(viewModel: viewModel)
    }
}
