//
//  ContentView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true // Tracks whether the loading screen is displayed

    var body: some View {
        Group {
            if isLoading {
                LoadingScreen() // Displays the loading screen
            } else {
                HomeView()
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
    ContentView()
}
