//
//  OnboardingView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/14/25.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
}

struct OnboardingView: View {
    let onboardingPages = [
        OnboardingPage(
            title: "Smarter Groceries",
            subtitle: "Track what you buy and never forget expiry dates again.",
            imageName: "groceries2"
        ),
        OnboardingPage(
            title: "Plan Your Meals",
            subtitle: "Get recipe suggestions based on what’s in your fridge.",
            imageName: "meals1"
        ),
        OnboardingPage(
            title: "Budget Like a Pro",
            subtitle: "Visualize your spending and stick to your student budget.",
            imageName: "budget"
        )
    ]

    @State private var currentPage = 0

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient Background
                AnimatedBackground()

                VStack {
                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            VStack(spacing: 24) {
                                Image(onboardingPages[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 280)
                                    .cornerRadius(20)
                                    .shadow(radius: 8)

                                VStack(spacing: 12) {
                                    Text(onboardingPages[index].title)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)

                                    Text(onboardingPages[index].subtitle)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.horizontal)
                                }
                            }
                            .tag(index)
                            .padding()
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                    .frame(maxHeight: .infinity)

                    if currentPage == onboardingPages.count - 1 {
                        VStack(spacing: 12) {
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up For Free")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [Color.blue, Color.purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                            }
                            .padding(.horizontal)

                            NavigationLink(destination: LoginView()) {
                                Text("Already have an account? Log In")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: currentPage)
                        .padding(.bottom, 40)
                    } else {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}

