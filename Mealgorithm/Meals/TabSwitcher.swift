//
//  TabSwitcher.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/25/25.
//

import SwiftUI

struct TabSwitcher: View {
    @Binding var selectedTab: String

    let tabs = ["Current", "Past"]

    var body: some View {
        ZStack(alignment: .leading) {
            // Background capsule
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.15))
                .frame(height: 30)

            // Moving Capsule for selection
            HStack {
                if selectedTab == "Past" {
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing))
                    .frame(width: UIScreen.main.bounds.width / 2 - 32, height: 30)
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedTab)

            // Text Buttons
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Button {
                        withAnimation {
                            selectedTab = tab
                        }
                    } label: {
                        Text(tab)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(selectedTab == tab ? .white : .primary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
