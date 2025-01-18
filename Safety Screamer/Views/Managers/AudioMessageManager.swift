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

    // Play an audio message by its filename
    func playAudioMessage(event drivingEvent: String) {
        if (isPlaying()) {
            print("Message already playing. Skipping call")
            return
        }
        
        let fileName = generateFileName(event: drivingEvent)
        
        // Get the path to the audio file in the Resources folder
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("Error: Audio file \(fileName) not found in Resources folder.")
            return
        }

        let url = URL(fileURLWithPath: path)

        do {
            // Initialize the audio player with the file's URL
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Playing audio message: \(fileName)")
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
    
    /// Returns a random filename for whatever driving thing the user did right/wrong.
    ///
    /// - Parameters:
    ///     - safetyEvent: Something the user did while driving ("speeding", "onPhone", etc)
    private func generateFileName(event drivingEvent: String) -> String {
        
        
        return ""
    }
}
