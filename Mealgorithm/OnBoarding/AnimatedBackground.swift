//
//  AnimatedBackground.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/26/25.
//

import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.indigo, Color.blue]),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .topLeading
        )
        .animation(
            Animation.easeInOut(duration: 6).repeatForever(autoreverses: true),
            value: animateGradient
        )
        .ignoresSafeArea()
        .onAppear {
            animateGradient.toggle()
        }
    }
}

#Preview {
    AnimatedBackground()
}

