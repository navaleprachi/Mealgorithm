//
//  PieChartView.swift
//  Mealgorithm
//
//  Created by Prachi Navale on 4/23/25.
//

import SwiftUI

struct PieChartView: View {
    @State private var animateChart = false
    let animateTrigger: Bool
    
    let data: [String: Double]
    let title: String

    var total: Double {
        data.values.reduce(0, +)
    }

    let categoryColors: [String: Color] = [
        "Rent": .blue,
        "Groceries": .green,
        "Dining": .orange,
        "Shopping": .purple,
        "Miscellaneous": .pink
    ]

    var slices: [(category: String, value: Double, color: Color, startAngle: Angle, endAngle: Angle)] {
        var currentAngle = -90.0
        return data.map { (category, value) in
            let angle = (value / total) * 360
            let start = Angle(degrees: currentAngle)
            let end = Angle(degrees: currentAngle + angle)
            let color = categoryColors[category] ?? .gray
            currentAngle += angle
            return (category, value, color, start, end)
        }
    }

    var body: some View {
        HStack(spacing: 24) {
            ZStack {
                GeometryReader { geometry in
                    let size = min(geometry.size.width, geometry.size.height)
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    ZStack {
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        let size = min(geometry.size.width, geometry.size.height)
                        
                        let animatedSlices: [(start: Double, end: Double, slice: (category: String, value: Double, color: Color))] = {
                            var result: [(Double, Double, (String, Double, Color))] = []
                            var start = -90.0
                            for s in slices {
                                let angle = s.endAngle.degrees - s.startAngle.degrees
                                let end = start + (animateChart ? angle : 0)
                                result.append((start, end, (s.category, s.value, s.color)))
                                start += angle
                            }
                            return result
                        }()

                        ForEach(animatedSlices, id: \.slice.category) { arc in
                            PieSlice(
                                startAngle: Angle(degrees: arc.start),
                                endAngle: Angle(degrees: arc.end),
                                center: center,
                                radius: size / 2,
                                color: arc.slice.color,
                                label: "\(Int((arc.slice.value / total) * 100))%"
                            )
                        }
                    }


                    // Donut center
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.5, height: size * 0.5)
                        .position(center)

                    // Total label
                    VStack {
                        Text("Total")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("$\(total, specifier: "%.2f")")
                            .font(.headline)
                            .bold()
                    }
                    .position(center)
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal)
            }
            .frame(height: 250)

            // Legend
            VStack(alignment: .leading, spacing: 8) {
                ForEach(slices, id: \.category) { slice in
                    HStack {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 10, height: 10)
                        Text(slice.category)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear{
            withAnimation(.easeOut(duration: 1.2)) {
                animateChart = true
            }
        }
        .onChange(of: animateTrigger) { triggered in
            if triggered {
                animateChart = false

                withAnimation(.easeOut(duration: 1.2)) {
                    animateChart = true
                }
            }
        }

    }
}


struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let center: CGPoint
    let radius: CGFloat
    let color: Color
    let label: String

    var body: some View {
        ZStack{
            Path { path in
                path.move(to: center)
                path.addArc(center: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false)
            }
            .fill(color)
            
            // Label slightly towards outer side
            let midAngle = Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
            let labelRadius = radius * 0.78
            let labelX = center.x + cos(midAngle.radians) * labelRadius
            let labelY = center.y + sin(midAngle.radians) * labelRadius

            Text(label)
                .font(.caption2)
                .foregroundColor(.white)
                .bold()
                .position(x: labelX, y: labelY)
        }
    }
}

#Preview {
    PieChartView(
        animateTrigger: true,
        data: [
            "Rent": 1000,
            "Groceries": 300,
            "Dining": 150,
            "Shopping": 200,
            "Misc": 100
        ],
        title: "Planned Spending"
    )
    .padding()
}
