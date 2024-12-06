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
                Color.white
                    .ignoresSafeArea()

                VStack {
                    DashboardHeader()

                    Spacer() // Push the rest of the content down

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

