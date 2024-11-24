//
//  HomeView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                NavigationLink(destination: AssistantView()) {
                    Text("Start Drive")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100) // Set width and height equal
                        .background(Color.blue)
                        .clipShape(Circle()) // Makes the shape circular
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
