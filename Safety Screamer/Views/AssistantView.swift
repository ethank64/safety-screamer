//
//  AssistantView.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 11/23/24.
//

import SwiftUI
import AVFoundation

struct AssistantView: View {
    @Environment(\.scenePhase) var scenePhase // Observe the app's lifecycle
    @Environment(\.presentationMode) var presentationMode
    @State private var emoji: String = "😐" // Default emoji
    @State private var audioPlayer: AVAudioPlayer?

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
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onChange(of: scenePhase) { oldValue, newValue in
            // Handle changes between scene phases
            switch newValue {
            case .background:
                print("App moved to the background.")
                handleAppBackgrounding()
            case .active:
                print("App became active.")
            case .inactive:
                print("App became inactive.")
            default:
                break
            }
        }
        .onAppear {
            setupAudio()
        }
    }

    // Set up the audio player
    private func setupAudio() {
        guard let path = Bundle.main.path(forResource: "momGuilt", ofType: "mp3") else {
            print("Audio file not found")
            return
        }
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to initialize audio player: \(error.localizedDescription)")
        }
    }

    // Handle app backgrounding
    private func handleAppBackgrounding() {
        audioPlayer?.play() // Play the audio file when the app goes to the background
    }
}

#Preview {
    AssistantView()
}
