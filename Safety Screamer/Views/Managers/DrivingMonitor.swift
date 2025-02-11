//
//  DrivingMonitor.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 2/11/25.
//
//  Description:
//  Subscribes to observables (notifications) from other manager classes and handles all of the driving events
//  from them. Also invokes the AudioMessageManager.
//

import SwiftUI
import BackgroundTasks

class DrivingMonitor: ObservableObject {
    @Published var isDrivingSafely: Bool = true // Observable for UI updates

    // Dependencies
    private let speedManager = SpeedManager()
    private let speedLimitManager = SpeedLimitManager()
    private let phoneActivityManager = PhoneActivityManager()
    private let audioMessageManager = AudioMessageManager()
    private let debugging = true

    // We no longer use a Timer; instead, location updates trigger evaluations.
    private var lastUnsafeEvent: String?
    
    // Store the observer so you can remove it later if needed.
    private var phoneActiveObserver: NSObjectProtocol?

    deinit {
        stopMonitoring()
        if let observer = phoneActiveObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func startMonitoring() {
        // Start receiving location updates (configured for background updates)
        LocationManager.shared.startMonitoring()
        // Start monitoring app state changes
        phoneActivityManager.monitorAppState()
        
        // Subscribe to the phone-did-become-active notification.
        phoneActiveObserver = NotificationCenter.default.addObserver(
            forName: .phoneDidBecomeActive,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            // Trigger the unsafe driving event when the phone becomes active.
            self?.handleUnsafeDriving(event: "onPhone")
        }
        
        isDrivingSafely = true
        lastUnsafeEvent = nil
        
        registerBackgroundTask()
        
        // Use the location listener to trigger safety evaluations.
        LocationManager.shared.addListener { [weak self] location in
            self?.evaluateDrivingSafety()
        }
    }

    func stopMonitoring() {
        LocationManager.shared.stopMonitoring()
        phoneActivityManager.stopMonitoringAppState()
        resetSafetyStatus()
    }

    private func evaluateDrivingSafety() {
        let currentSpeed = speedManager.getSpeed()
        let speedLimit = speedLimitManager.getSpeedLimit()
        let isOnPhone = phoneActivityManager.getIsOnPhone()
        
        if debugging {
            print("Evaluating driving safety...")
            print("User speed: \(currentSpeed)")
            print("Speed limit: \(speedLimit)")
            print("Is on phone: \(isOnPhone)")
        }
        
        // Evaluate safety only when the user is not actively using the phone.
        if !isOnPhone {
            if isSpeeding(currentSpeed: currentSpeed, speedLimit: speedLimit) {
                handleUnsafeDriving(event: "speeding")
            } else {
                handleSafeDriving()
            }
        } else {
            // When the user is actively on the phone, skip evaluation.
            print("User is actively using the phone. Skipping driving safety evaluation.")
        }
    }

    private func isSpeeding(currentSpeed: Int, speedLimit: Int) -> Bool {
        // If speed limit is 0, just assume that there is none
        return (currentSpeed > speedLimit) && speedLimit != 0
    }
    
    func getSafetyStatus() -> Bool {
        return isDrivingSafely
    }

    // Called when driving is safe. (This method does not trigger an audio alert.)
    private func handleSafeDriving() {
        if !isDrivingSafely {
            lastUnsafeEvent = nil
            print("Driving safely!")
        }
    }
    
    public func resetSafetyStatus() {
        isDrivingSafely = true
    }

    public func handleUnsafeDriving(event: String) {
        isDrivingSafely = false
        
        // Only trigger a new event if it differs from the previous one.
        if lastUnsafeEvent != event {
            lastUnsafeEvent = event
            print("Unsafe driving detected: \(event)")
            
            // Play the corresponding audio message.
            audioMessageManager.playAudioMessage(event: event)
        }
    }

    // Register a background task so the system can wake your app for location updates.
    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.safetyscreamer", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }

    // Handle background execution. (BGTasks are scheduled at the system’s discretion.)
    private func handleBackgroundTask(task: BGProcessingTask) {
        task.expirationHandler = {
            self.stopMonitoring()
            task.setTaskCompleted(success: false)
        }
        
        evaluateDrivingSafety()
        task.setTaskCompleted(success: true)
    }
}
