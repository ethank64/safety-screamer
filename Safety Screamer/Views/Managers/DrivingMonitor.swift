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
    private var lastUnsafeEvent: String?

    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        LocationManager.shared.startMonitoring()
        phoneActivityManager.monitorAppState()
        
        isDrivingSafely = true
        lastUnsafeEvent = nil
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.evaluateDrivingSafety()
        }
    }

    func stopMonitoring() {
        LocationManager.shared.stopMonitoring()
        phoneActivityManager.stopMonitoringAppState()
        resetSafetyStatus()
        
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

    // DOES NOT play audio.
    private func handleSafeDriving() {
        if !isDrivingSafely {
            lastUnsafeEvent = nil
            print("Driving safely!")
        }
    }
    
    public func resetSafetyStatus() {
        isDrivingSafely = true
    }

    private func handleUnsafeDriving(event: String) {
        if lastUnsafeEvent != event {
            isDrivingSafely = false
            lastUnsafeEvent = event
            print("Unsafe driving detected: \(event)")
            
            audioMessageManager.playAudioMessage(event: "\(event)")
        }
    }
}
