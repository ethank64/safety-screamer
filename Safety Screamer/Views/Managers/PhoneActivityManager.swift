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
            selector: #selector(handleAppOpened),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppExited),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    // Called when the app is opened or comes to the foreground
    @objc private func handleAppOpened(_ notification: Notification) {
        isOnPhone = false
        print("User returned to the app (isOnPhone = false).")
    }

    // Called when the user actively exits the app (like pressing the home button)
    @objc private func handleAppExited(_ notification: Notification) {
        isOnPhone = true
        print("User navigated to home screen or switched apps (isOnPhone = true).")
    }
    
    // Called when the app enters the background (screen locked)
    @objc private func handleAppBackground(_ notification: Notification) {
        isOnPhone = true
        print("User locked the screen or turned off the phone (isOnPhone = false).")
    }

    func stopMonitoringAppState() {
        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        stopMonitoringAppState()
    }
}
