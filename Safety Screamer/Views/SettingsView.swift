//
//  SettingsView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/5/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("usingMetric") private var usingMetric = false // Persistent storage
    
    @State private var notificationsOn = true
    @State private var darkModeOn = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Divider()
                .padding(.bottom, 8)
            
            SettingRow(title: "Enable Notifications", isOn: $notificationsOn)
            SettingRow(title: "Dark Mode", isOn: $darkModeOn)
            SettingRow(title: "Use Metric System", isOn: $usingMetric) // Now uses @AppStorage
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
