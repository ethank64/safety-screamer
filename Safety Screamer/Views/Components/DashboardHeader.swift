//
//  DashboardHeader.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/5/24.
//

import SwiftUI

struct DashboardHeader: View {
    var body: some View {
        // Top row with title and settings button
        HStack {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer() // Push the settings icon to the right
            
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape")
                    .font(.title2) // Adjust icon size
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
    
#Preview {
    DashboardHeader()
}
