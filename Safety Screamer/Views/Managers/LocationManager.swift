//
//  LocationManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/16/25.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    // Instance of Core Location's class
    private let coreLocationManager = CLLocationManager()
    private var listeners: [(CLLocation) -> Void] = [] // Store multiple closures

    public override init() {
        super.init()
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        coreLocationManager.requestWhenInUseAuthorization()
    }

    func addListener(_ listener: @escaping (CLLocation) -> Void) {
        listeners.append(listener)
    }

    // Built in method that's part of the CLLocationManager
    // Automatically updates the listeners with the new location value
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        for listener in listeners {
            listener(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
