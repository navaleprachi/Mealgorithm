//
//  SocialLoginButton.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/15/25.
//

import SwiftUI

struct SocialLoginButton: View {
    var title: String
    var icon: String
    var backgroundColor: Color
    var foregroundColor: Color

    @State private var isPressed = false

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            if icon == "google" {
                Image("google")
                    .resizable()
                    .frame(width: 22, height: 22)
            } else if icon == "facebook" {
                Image("facebook")
                    .resizable()
                    .frame(width: 22, height: 22)
            } else {
                Image(systemName: icon)
                    .font(.title3)
            }

            // Text
            Text(title)
                .fontWeight(.semibold)
                .font(.subheadline)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(foregroundColor.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.easeOut(duration: 0.2), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
        }, perform: {})
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 16) {
        SocialLoginButton(title: "Continue with Google", icon: "google", backgroundColor: .white, foregroundColor: .black)
        SocialLoginButton(title: "Continue with Apple", icon: "apple.logo", backgroundColor: .black, foregroundColor: .white)
        SocialLoginButton(title: "Continue with Facebook", icon: "facebook", backgroundColor: .white, foregroundColor: .blue)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
