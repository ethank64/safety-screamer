//
//  AssistantView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//

import SwiftUI
import AVFoundation

struct AssistantView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Speed Limit
                SpeedLimitSign()

                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    AssistantView()
}
