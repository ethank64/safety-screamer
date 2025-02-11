//
//  AudioMessageManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/16/25.
//
//  Description:
//  Manages audio playback for various driving events. Configures the audio session
//  to allow playback in the background and plays a random audio file for the specified event.
//

import Foundation
import AVFoundation

class AudioMessageManager: NSObject {
    private var audioPlayer: AVAudioPlayer?
    
    // Dictionary mapping each event to the number of available audio files.
    private let audioFileCounts: [String: Int] = [
        "onPhone": 5,
        "speeding": 6,
        "encouraging": 4
    ]
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    /// Configures the AVAudioSession for background playback.
    /// This is essential for playing audio when the app is in the background.
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // Set the category to playback to allow background audio.
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            print("Audio session activated successfully.")
        } catch {
            print("Failed to activate audio session: \(error.localizedDescription)")
        }
    }
    
    /// Plays an audio message corresponding to the given driving event.
    ///
    /// - Parameter drivingEvent: The event that triggered the audio message (e.g., "onPhone", "speeding").
    func playAudioMessage(event drivingEvent: String) {
        // Prevent overlapping audio messages.
        if isPlaying() {
            print("Message already playing. Skipping call.")
            return
        }
        
        // Ensure the audio session is properly set up.
        setupAudioSession()
        
        // Generate a random file name for the event.
        guard let fileName = generateFileName(for: drivingEvent) else {
            print("Error: Invalid or missing audio file for event \(drivingEvent).")
            return
        }
        
        do {
            // Locate the audio file in the app bundle.
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
                print("Error: Audio file \(fileName).mp3 not found.")
                return
            }
            
            // Initialize and prepare the audio player.
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Playing audio message: \(fileName)")
        } catch {
            print("Error: Unable to play audio file \(fileName). \(error.localizedDescription)")
        }
    }
    
    /// Stops the currently playing audio message, if any.
    func stopAudioMessage() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            print("Audio playback stopped.")
        }
    }
    
    /// Checks if an audio message is currently playing.
    ///
    /// - Returns: `true` if audio is playing; otherwise, `false`.
    func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    /// Generates a random file name for the specified driving event.
    ///
    /// - Parameter drivingEvent: The driving event (e.g., "onPhone", "speeding").
    /// - Returns: A file name string if audio files are available for the event, or `nil` otherwise.
    private func generateFileName(for drivingEvent: String) -> String? {
        guard let count = audioFileCounts[drivingEvent], count > 0 else {
            print("Error: No audio files available for event \(drivingEvent).")
            return nil
        }
        let randomNum = Int.random(in: 0..<count)
        return "\(drivingEvent)\(randomNum)"
    }
}
