//
//  HomeView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//
//  Description:
//  The main view that is displayed once the app loads. Accesses
//  drive mode, settings, and previous drives.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemBackground)
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

