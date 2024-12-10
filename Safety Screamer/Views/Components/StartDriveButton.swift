//
//  StartDriveButton.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/5/24.
//

import SwiftUI

struct StartDriveButton: View {
    var body: some View {
        NavigationLink(destination: DrivingView()) {
            Text("Start Drive")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 200, height: 60) // Rectangle dimensions
                .background(Color.blue)
                .cornerRadius(15)
        }
    }
}

#Preview {
    StartDriveButton()
}
