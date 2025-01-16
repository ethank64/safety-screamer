//
//  SpeedLimitView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/4/24.
//

import SwiftUI
import CoreLocation

struct SpeedLimitSign: View {
    @AppStorage("usingMetric") private var usingMetric = false
    @StateObject private var speedLimitManager = SpeedLimitManager()

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
                Text("\(speedLimitManager.speedLimit ?? 0)") // Display speed limit or fallback to 0
                    .font(.system(size: 100, weight: .bold, design: .default)) // Large font size
                    .foregroundColor(.black)
                Text(usingMetric ? (speedLimitManager.speedLimitUnit == "K" ? "KPH" : "MPH") : "MPH") // Use unit from manager
                    .font(.system(size: 30, weight: .medium, design: .default))
            }
        }
        .onAppear {
            // Optionally fetch speed limit for a default location (for testing or initial load)
            let sampleCoordinate = CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
            speedLimitManager.fetchSpeedLimit(for: sampleCoordinate)
        }
    }
}

#Preview {
    SpeedLimitSign()
}
