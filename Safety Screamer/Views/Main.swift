//
//  Main.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//
//  Description:
//  Entry point of the app. Displays the Home view.
//

import SwiftUI

struct Main: View {
    @AppStorage("darkModeOn") private var darkModeOn = false

    var body: some View {
        Group {
            HomeView()
                .preferredColorScheme(darkModeOn ? .dark : .light)
        }
    }
}

#Preview {
    Main()
}
