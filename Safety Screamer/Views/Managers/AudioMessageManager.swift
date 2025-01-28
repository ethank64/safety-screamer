//
//  AudioMessageManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/17/25.
//
//  Description:
//  Manages the playing of guilty or encouraging audio messages.
//

import Foundation
import AVFoundation

class AudioMessageManager: NSObject {
    private var audioPlayer: AVAudioPlayer?

    private let audioFileCounts: [String: Int] = [
        "onPhone": 1,
        "speeding": 0,
        "encouraging": 0
    ]

    // Play an audio message by its event type
    func playAudioMessage(event drivingEvent: String) {
        if isPlaying() {
            print("Message already playing. Skipping call.")
            return
        }

        guard let fileName = generateFileName(for: drivingEvent) else {
            print("Error: Invalid or missing audio file for event \(drivingEvent).")
            return
        }

        do {
            // Construct the URL for the audio file
            guard let url = Bundle.main.url(forResource: "0", withExtension: "mp3") else {
                print("Error: Audio file \(fileName) not found in \(drivingEvent) folder.")
                return
            }

            // Initialize and play the audio
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Playing audio message: \(fileName).mp3 in \(drivingEvent) folder.")
        } catch {
            print("Error: Unable to play audio file \(fileName). \(error.localizedDescription)")
        }
    }

    // Stop the currently playing audio message
    func stopAudioMessage() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            print("Audio playback stopped.")
        }
    }

    // Check if an audio message is currently playing
    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }

    // Generate a random file name for the given driving event
    private func generateFileName(for drivingEvent: String) -> String? {
        guard let count = audioFileCounts[drivingEvent], count > 0 else {
            print("Error: No audio files available for event \(drivingEvent).")
            return nil
        }

        let randomNum = Int.random(in: 0..<count)
        return "\(randomNum)"
    }
}
