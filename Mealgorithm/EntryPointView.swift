//
//  EntryPointView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/16/25.
//

import SwiftUI

struct EntryPointView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("didCompleteSetup") private var didCompleteSetup: Bool = false

    @State private var showSplash = true

    var body: some View {
        Group{
            if showSplash {
                SplashScreenView()
            } else {
                if isLoggedIn {
                    if didCompleteSetup {
                        ContentView()
                    } else {
                        BasicInfoView()
                    }
                } else {
                    OnboardingView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    EntryPointView()
}

