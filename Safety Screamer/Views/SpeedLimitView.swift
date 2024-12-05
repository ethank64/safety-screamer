//
//  SpeedLimitView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/4/24.
//

import SwiftUI

struct SpeedLimitView: View {
    var speedLimit: Int

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 50)
                .cornerRadius(8)
            Text("\(speedLimit)")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
