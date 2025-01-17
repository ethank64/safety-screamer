//
//  SettingRow.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/5/24.
//
//  Description:
//  Defines how a toggle item in the settings menu should look.
//

import SwiftUI

struct SettingRow: View {
    var title: String
    @Binding var isOn: Bool // Need binding to make changes from the parent view (Settings)
    
    var body: some View {
        HStack {
            Text(title) // Setting title
                .font(.body) // Customize font as neede
            
            Spacer()
            
            Toggle("", isOn: $isOn) // The toggle switch
                .labelsHidden() // Hides the toggle label
        }
        .padding() // Add padding for a clean look
    }
}

#Preview {
    @Previewable @State var isOn = false // Temporary state for preview
    return SettingRow(title: "Test", isOn: $isOn)
}
