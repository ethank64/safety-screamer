//
//  DrivingMonitor.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/16/25.
//
//  Description:
//  Takes in phone usage data, speed data, and speed limit data and checks
//  whether the user is driving safely. If not, it takes the necessary
//  action.
//

import SwiftUI

class DrivingMonitor: ObservableObject {
    @Published var isDrivingSafely: Bool = true // Observable for UI updates

    // Dependencies
    private let speedManager = SpeedManager()
    private let speedLimitManager = SpeedLimitManager()
    private let phoneActivityManager = PhoneActivityManager()
    private let audioMessageManager = AudioMessageManager()

    private var timer: Timer?

    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        // Start managers
        // Setting this bool for LocationManager starts/stops speed/speed limit monitoring
        LocationManager.shared.startMonitoring()
        phoneActivityManager.monitorAppState()
        
        // Always make sure each drive starts out as safe
        isDrivingSafely = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.evaluateDrivingSafety()
        }
    }

    func stopMonitoring() {
        LocationManager.shared.stopMonitoring()
        phoneActivityManager.stopMonitoringAppState()
        
        timer?.invalidate()
        timer = nil
    }

    private func evaluateDrivingSafety() {
        print("Evaluating...")
        let currentSpeed = speedManager.getSpeed()
        let speedLimit = speedLimitManager.getSpeedLimit()
        let isOnPhone = phoneActivityManager.getIsOnPhone()
        print("User speed: \(currentSpeed)")
        print("Speed limit: \(speedLimit)")
        print("On phone: \(isOnPhone)")

        if isSpeeding(currentSpeed: currentSpeed, speedLimit: speedLimit) {
            handleUnsafeDriving(event: "speeding")
        } else if isOnPhone {
            handleUnsafeDriving(event: "onPhone")
        } else {
            handleSafeDriving()
        }
    }

    private func isSpeeding(currentSpeed: Int, speedLimit: Int) -> Bool {
        return currentSpeed > speedLimit
    }
    
    func getSafetyStatus() -> Bool {
        return isDrivingSafely
    }

    private func handleSafeDriving() {
        if !isDrivingSafely {
            isDrivingSafely = true
            print("Driving safely!")
            // Perform actions for safe driving (optional, e.g., encouragement messages)
        }
    }

    private func handleUnsafeDriving(event: String) {
        if isDrivingSafely {
            isDrivingSafely = false
            print("Unsafe driving detected: \(event)")
            // Play a guilt-inducing audio message
            audioMessageManager.playAudioMessage(event: "\(event)")
//            audioMessageManager.playSound()
        }
    }
}
