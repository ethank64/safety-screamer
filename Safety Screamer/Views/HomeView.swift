//
//  HomeView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()

                // Main content
                VStack {
                    DashboardHeader(size: 45)
                    
                    SafetyStreak()

                    StartDriveButton()
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

