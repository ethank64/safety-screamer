//
//  SpeedLimitView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/4/24.
//

import SwiftUI

struct SpeedLimitView: View {
    @AppStorage("usingMetric") private var usingMetric = false
    
    var speedLimit: Int = 25

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 225, height: 300)
                .cornerRadius(8)
                .overlay(       // Border
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2)
                )
            VStack {
                Text("\(speedLimit)")     // Convert speedLimit to a string
                    .font(.system(size: 100, weight: .bold, design: .default)) // Set a larger font size
                    .foregroundColor(.black)
                Text(usingMetric ? "KPH" : "MPH")
                    .font(.system(size: 30, weight: .medium, design: .default))
            }

        }
    }
}

#Preview {
    SpeedLimitView()
}
