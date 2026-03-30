//
//  LoginView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/14/25.
//

//
//  LoginView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/14/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = "Admin"
    @State private var password = "admin"
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("didCompleteSetup") private var didCompleteSetup: Bool = false
    @State private var isLoading = false
    @State private var showErrorToast = false
    @State private var errorMessage = ""
    @State private var showSuccessToast = false


    var body: some View {
        Group {
            if isLoggedIn {
                if didCompleteSetup {
                    ContentView()
                } else {
                    BasicInfoView()
                }
            } else {
                loginScreen
            }
        }
    }

    var loginScreen: some View {
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
                        Text("Welcome Back!")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)

                        inputField(icon: "envelope.fill", placeholder: "Email Address", text: $email)
                        secureInputField(icon: "lock.fill", placeholder: "Password", text: $password)

                        LoadingButton(title: "Log In", action: {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                if email.lowercased() == "admin" && password == "admin" {
                                    withAnimation {
                                        showSuccessToast = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation {
                                            isLoggedIn = true
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        errorMessage = "Invalid email or password."
                                        showErrorToast = true
                                    }
                                }
                                isLoading = false
                            }
                        }, isLoading: isLoading)
                        .padding(.top)



                        Button(action: {
                            // Navigate to Forgot Password
                        }) {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 6)
                    }
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(20)
                    .shadow(radius: 8)
                    .padding(.horizontal)

                    // OR Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.4))

                        Text("OR")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.4))
                    }
                    .padding(.horizontal)

                    // Social Logins
                    VStack(spacing: 12) {
                        SocialLoginButton(title: "Continue with Google", icon: "google", backgroundColor: .white, foregroundColor: .black)
                        SocialLoginButton(title: "Continue with Apple", icon: "apple.logo", backgroundColor: .black, foregroundColor: .white)
                        SocialLoginButton(title: "Continue with Facebook", icon: "facebook", backgroundColor: .white, foregroundColor: .blue)
                    }
                    .padding(.horizontal)

                    Text("We will never post anything without your permission.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
                
                .overlay(
                    Group {
                        if showErrorToast {
                            toastView(message: errorMessage, backgroundColor: .red)
                        } else if showSuccessToast {
                            toastView(message: "Login successful!", backgroundColor: .green)
                        }
                    }
                )

            }
            .navigationTitle("Log In")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                Group {
                    if showErrorToast {
                        VStack {
                            Spacer()
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red.opacity(0.9))
                                .cornerRadius(10)
                                .padding(.bottom, 50)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showErrorToast = false
                                        }
                                    }
                                }
                        }
                        .padding(.horizontal)
                    }
                }
            )
            .hideKeyboardOnTap()
        }
    }

    // MARK: - Reusable Components

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
                .font(.caption)
                .foregroundColor(.white)
                .padding()
                .background(backgroundColor.opacity(0.9))
                .cornerRadius(10)
                .padding(.bottom, 50)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showErrorToast = false
                            showSuccessToast = false
                        }
                    }
                }
        }
        .padding(.horizontal)
    }
}

#Preview {
    LoginView()
}

