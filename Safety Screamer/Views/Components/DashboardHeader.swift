//
//  DashboardHeader.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/5/24.
//

import SwiftUI

struct DashboardHeader: View {
    var size: CGFloat
    
    var body: some View {
        VStack {
            // Top row with title and settings button
            HStack {
                Text("Dashboard")
                    .font(.system(size: size))
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: size * 0.7)) // Scale Icon size
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            Divider()
                .background(Color.primary)
                
        }
    }
}
    
#Preview {
    DashboardHeader(size: 50)
}
