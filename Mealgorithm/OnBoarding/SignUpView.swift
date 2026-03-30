//
//  SignUpView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var navigateToBasicInfo = false

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastColor = Color.green
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.blue.opacity(0.3),
                            Color.indigo.opacity(0.3)
                        ]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("Create Account")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)

                        inputField(icon: "envelope.fill", placeholder: "Email Address", text: $email)
                        secureInputField(icon: "lock.fill", placeholder: "Password", text: $password)
                        secureInputField(icon: "lock.rotation.open", placeholder: "Confirm Password", text: $confirmPassword)
                    }
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(20)
                    .shadow(radius: 8)
                    .padding(.horizontal)

                    LoadingButton(title: "Create Account", action: handleSignUp, isLoading: isLoading)
                        .padding(.horizontal)
                        .padding(.top)

                    Spacer()
                }
                .padding(.top)
                .navigationTitle("Sign Up")
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $navigateToBasicInfo) {
                    BasicInfoView()
                }
                if showToast {
                    toastView(message: toastMessage, backgroundColor: toastColor)
                }
            }
            .hideKeyboardOnTap()
        }
    }

    // MARK: - Sign Up Logic

    func handleSignUp() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            showToast(message: "All fields are required.", color: .red)
            return
        }

        guard isValidEmail(email) else {
            showToast(message: "Invalid email address.", color: .red)
            return
        }

        guard password == confirmPassword else {
            showToast(message: "Passwords do not match.", color: .red)
            return
        }

        // Success Path
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            showToast(message: "Account created successfully!", color: .green)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                navigateToBasicInfo = true
            }
        }
    }

    func showToast(message: String, color: Color) {
        toastMessage = message
        toastColor = color
        showToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showToast = false
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    // MARK: - UI Components

    @ViewBuilder
    func inputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            TextField(placeholder, text: text)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    func secureInputField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            SecureField(placeholder, text: text)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    func toastView(message: String, backgroundColor: Color) -> some View {
        VStack {
            Spacer()
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor.opacity(0.95))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 30)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut, value: showToast)
    }
}

#Preview {
    SignUpView()
}

