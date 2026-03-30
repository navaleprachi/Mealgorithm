//
//  SplashScreenView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/14/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            // Smooth App Themed Gradient Background
            AnimatedBackground()

            VStack(spacing: 20) {
                
                 Image("mealgorithm_icon")
                     .resizable()
                     .scaledToFit()
                     .frame(width: 120, height: 120)
                     .clipShape(RoundedRectangle(cornerRadius: 24))
                     .shadow(radius: 10)

                Text("Mealgorithm")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)

                Text("Your Life. In Sync.")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.85))

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.3)
                    .padding(.top, 24)
            }
            .padding()
        }
    }
}

#Preview {
    SplashScreenView()
}
