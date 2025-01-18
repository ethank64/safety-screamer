//
//  AssistantView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//
//  Description:
//  The view when a drive is active. Users can see the
//  current speed limit, their speed, and exit drive mode.
//

import SwiftUI

struct DrivingView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("safetyStreak") private var safetyStreak = 0
    
    private var locationManager = LocationManager.shared
    @StateObject private var speedManager = SpeedManager()
    private var drivingMonitor = DrivingMonitor()

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Speed Limit
                SpeedLimitSign()
                
                // Current speed
                Text("Current Speed: \(speedManager.speed, specifier: "%.2f")")

                Spacer()

                // Stop drive button
                Button(action: {
                    if (drivingMonitor.getSafetyStatus()) {
                        safetyStreak += 1
                    } else {
                        safetyStreak = 0
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                    drivingMonitor.stopMonitoring()
                }) {
                    Text("Stop Drive")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            }
            .onAppear {
                locationManager.requestPermission()
                drivingMonitor.startMonitoring()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    DrivingView()
}
