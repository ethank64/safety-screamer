//
//  Main.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//

// The main view
import SwiftUI

struct Main: View {
    @State private var isLoading = true // Tracks whether the loading screen is displayed
    @AppStorage("darkModeOn") private var darkModeOn = false
    @StateObject private var speedLimitManager = SpeedLimitManager()

    var body: some View {
        Group {
            if isLoading {
                LoadingScreen() // Displays the loading screen
                    .preferredColorScheme(darkModeOn ? .dark : .light)
            } else {
                HomeView()
                    .preferredColorScheme(darkModeOn ? .dark : .light)
            }
        }
        .onAppear {
            simulateLoading()
        }
    }

    // Simulate a loading delay
    private func simulateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Adjust the delay as needed
            isLoading = false
        }
    }
}

#Preview {
    Main()
}
