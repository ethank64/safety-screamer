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
                .frame(width: 100, height: 100) // Set width and height equal
                .background(Color.blue)
                .clipShape(Circle()) // Makes the shape circular
        }
    }
}

#Preview {
    StartDriveButton()
}
