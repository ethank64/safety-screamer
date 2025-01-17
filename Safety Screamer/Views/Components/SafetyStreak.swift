//
//  SafetyStreak.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 12/9/24.
//
//  Description:
//  A component that displays how many safe drives in a row the user has
//  done.
//

import SwiftUI

struct SafetyStreak: View {
    var streakCount: Int = 0
    
    var body: some View {
        HStack {
            Text("Safety Streak: ")
                .font(.system(size: 40))
                .foregroundColor(.primary)
            Text("\(streakCount)")
                .font(.system(size: 40))
                .foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Align content to the left
        .padding()
    }
}

#Preview {
    SafetyStreak()
}
