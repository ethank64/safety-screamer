//
//  AssistantView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//

import SwiftUI

struct AssistantView: View {
    @Environment(\.presentationMode) var presentationMode // Allows dismissing the view
    @State private var emoji: String = "😐" // Default emoji

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Dynamic Emoji
                Text(emoji)
                    .font(.system(size: 100))
                    .padding()

                Spacer()

                // "Stop Drive" Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss AssistantView
                }) {
                    Text("Stop Drive")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hides the default back arrow
        .navigationBarHidden(true)          // Completely hides the navigation bar
    }
}

#Preview {
    AssistantView()
}
