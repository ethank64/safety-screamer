//
//  LoadingScreen.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//
//  Description:
//  The view that displays when the app is launched and is loading.
//

import SwiftUI

struct LoadingScreen: View {
    @State private var isLoading = true

    var body: some View {
        VStack {
            Spacer()
            
            // Safe Driving Message
            Text("Drive Safely!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .padding()
            
            // Safety Subtext
            Text("Remember to focus on the road, not your phone.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Loading Spinner
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            }
            
            Spacer()
        }
        .onAppear {
            simulateLoading()
        }
    }
    
    private func simulateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
        }
    }
}

#Preview {
    LoadingScreen()
}
