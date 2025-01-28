//
//  SpeedManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/16/25.
//
//  Description:
//  Holds onto the current speed of the user and updates it automatically
//  based on changes in their location. Speed automatically updates in
//  real time whenever the location changes.
//

import CoreLocation
import SwiftUI

class SpeedManager: NSObject, ObservableObject {
    @AppStorage("usingMetric") private var usingMetric = false
    @Published var speed: Double = 0.0 // Speed in meters per second

    override init() {
        super.init()
        LocationManager.shared.addListener { [weak self] location in
            self?.speed = max(location.speed, 0) // Update speed (speed < 0 means invalid)
        }
    }

    public func getSpeed() -> Int {
        return usingMetric ? convertToKPH(speed) : convertToMPH(speed)
    }

    private func convertToKPH(_ speedInMetersPerSecond: Double) -> Int {
        // Convert meters per second to kilometers per hour
        return Int(speedInMetersPerSecond * 3.6)
    }

    private func convertToMPH(_ speedInMetersPerSecond: Double) -> Int {
        // Convert meters per second to miles per hour
        return Int(speedInMetersPerSecond * 2.23694)
    }
}
