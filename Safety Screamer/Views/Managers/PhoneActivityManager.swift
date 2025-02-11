import SwiftUI
import UIKit

extension Notification.Name {
    static let phoneDidBecomeActive = Notification.Name("phoneDidBecomeActive")
}

class PhoneActivityManager: ObservableObject {
    // When true, the user is actively using the phone (i.e. the app is active).
    // When false, the user has gotten off the app.
    @Published var isOnPhone: Bool = false

    public func getIsOnPhone() -> Bool {
        return isOnPhone
    }

    // Monitor the app's state to determine if the user is actively using the phone.
    func monitorAppState() {
        // Called when the app becomes active (the user is on the phone).
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // Called when the app is about to resign active (the user gets off the app).
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    // Called when the app becomes active—indicating that the user is using the phone.
    @objc private func handleAppDidBecomeActive(_ notification: Notification) {
        isOnPhone = true
        print("User is using the phone (app did become active, isOnPhone = true).")
    }
    
    // Called when the app is about to resign active—indicating that the user has gotten off the app.
    @objc private func handleAppWillResignActive(_ notification: Notification) {
        isOnPhone = false
        print("User is no longer using the phone (app will resign active, isOnPhone = false).")
        
        // Post a notification so other parts of the app know the phone became active.
        NotificationCenter.default.post(name: .phoneDidBecomeActive, object: nil)
    }
    
    func stopMonitoringAppState() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        stopMonitoringAppState()
    }
}
