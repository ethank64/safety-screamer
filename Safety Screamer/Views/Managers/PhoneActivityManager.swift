//
//  PhoneActivityManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/17/25.
//
//  Description:
//  Tracks whether the user is actively using their phone, either on the home
//  page or within the app.
//

import SwiftUI

class PhoneActivityManager: ObservableObject {
    @Published var isOnPhone: Bool = false // True if user is actively on the phone
    
    public func getIsOnPhone() -> Bool {
        return isOnPhone
    }

    // Monitor the app's state to determine if the user is "on the phone"
    func monitorAppState() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppStateChange),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppStateChange),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    // Handle state changes to update `isOnPhone`
    @objc private func handleAppStateChange(_ notification: Notification) {
        switch notification.name {
        case UIApplication.didBecomeActiveNotification:
            isOnPhone = true
            print("User is now on the app (isOnPhone = true).")
        case UIApplication.willResignActiveNotification:
            isOnPhone = true
            print("User is now on the home page or switching apps (isOnPhone = true).")
        default:
            break
        }
    }
    
    func stopMonitoringAppState() {
        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        stopMonitoringAppState()
    }
}
