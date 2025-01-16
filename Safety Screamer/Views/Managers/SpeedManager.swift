//
//  SpeedManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/16/25.
//

import CoreLocation
import SwiftUI

class SpeedManager: NSObject, ObservableObject {
    @Published var speed: Double = 0.0 // Speed in meters per second

    override init() {
        super.init()
        LocationManager.shared.addListener { [weak self] location in
            self?.speed = max(location.speed, 0) // Update speed (speed < 0 means invalid)
        }
    }
}
