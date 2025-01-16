//
//  SettingsView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/5/24.
//

import SwiftUI

struct SettingsView: View {
    // Persistent storage
    @AppStorage("usingMetric") private var usingMetric = false
    @AppStorage("darkModeOn") private var darkModeOn = false
    @AppStorage("notificationsOn") private var notificationsOn = true

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Divider()
                .background(.primary)
                .padding(.bottom, 8)
                
            
            SettingRow(title: "Enable Notifications", isOn: $notificationsOn)
            SettingRow(title: "Dark Mode", isOn: $darkModeOn)
            SettingRow(title: "Use Metric System", isOn: $usingMetric)
            
            Spacer()
        }
        .padding()
        .preferredColorScheme(darkModeOn ? .dark : .light) // Apply dynamic color scheme
    }
}

#Preview {
    SettingsView()
}
