//
//  SpeedLimitView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/4/24.
//
//  Description:
//  This view displays a speed limit sign that updates dynamically
//  based on the user's location.
//

import SwiftUI
import CoreLocation

struct SpeedLimitSign: View {
    @AppStorage("usingMetric") private var usingMetric = false
    @StateObject private var speedLimitManager = SpeedLimitManager()
    
    // Set to true if you want to test the speed limit API
    private var debugging = true

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemBackground))
                .frame(width: 225, height: 300)
                .cornerRadius(8)
                .overlay(       // Border
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 2)
                )
            VStack {
                // Display speed limit or fallback to 0
                Text("\(speedLimitManager.getSpeedLimit())")
                    .font(.system(size: 100, weight: .bold, design: .default)) // Large font size
                Text(usingMetric ? "KPH" : "MPH")
                    .font(.system(size: 30, weight: .medium, design: .default))
            }
        }
        .onAppear {
            if (debugging) {
//                let sampleCoordinate = CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
                print("test?")
                if let coordinates = LocationManager.shared.getCurrentCoordinates() {
                    print("CLLocationCoordinate2D(latitude: \(coordinates.latitude), longitude: \(coordinates.longitude))");
                    print(coordinates)
                    speedLimitManager.fetchSpeedLimit(for: coordinates)
                } else {
                    print("Current coordinates are not available")
                }
            }
        }
    }
}

#Preview {
    SpeedLimitSign()
}
