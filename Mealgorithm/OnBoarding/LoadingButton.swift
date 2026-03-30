//
//  LoadingButton.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/26/25.
//

import SwiftUI

struct LoadingButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool

    var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.indigo],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .disabled(isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

#Preview {
    VStack(spacing: 20) {
        LoadingButton(title: "Log In", action: {}, isLoading: false)
        LoadingButton(title: "Create Account", action: {}, isLoading: true)
    }
    .padding()
    .background(Color("AppBackground").ignoresSafeArea())
}
