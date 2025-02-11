//
//  LocationManager.swift
//  Safety Screamer
//
//  Created by [Your Name] on [Date].
//
//  Description:
//  This LocationManager class provides continuous location updates—even in the background—by
//  requesting “always” authorization and enabling background location updates. Listeners can be added
//  to be notified whenever a location update is available.

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    // Instance of Core Location's class.
    private let coreLocationManager = CLLocationManager()
    
    // Array of listener closures that are notified when a new location is available.
    private var listeners: [(CLLocation) -> Void] = []
    
    // Flag to control whether we are actively monitoring.
    private var isMonitoring: Bool = false
    
    private var lastLocation: CLLocation?
    private var lastUpdateTime: Date = Date.distantPast
    private let updateInterval: TimeInterval = 3 // Only update every 3 seconds at most.
    
    public override init() {
        super.init()
        
        // Set the delegate and desired accuracy.
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request “always” authorization so that location updates are delivered in the background.
        coreLocationManager.requestAlwaysAuthorization()
        
        // Enable background location updates.
        coreLocationManager.allowsBackgroundLocationUpdates = true
        coreLocationManager.pausesLocationUpdatesAutomatically = false
        
        // Start updating the location.
        coreLocationManager.startUpdatingLocation()
    }
    
    /// Requests location permission again if needed.
    func requestPermission() {
        coreLocationManager.requestAlwaysAuthorization()
    }
    
    /// Returns the current coordinates if available.
    func getCurrentCoordinates() -> CLLocationCoordinate2D? {
        return coreLocationManager.location?.coordinate
    }
    
    /// Adds a listener closure that will be called whenever a new location is available.
    func addListener(_ listener: @escaping (CLLocation) -> Void) {
        listeners.append(listener)
    }
    
    /// Starts monitoring location updates.
    func startMonitoring() {
        isMonitoring = true
    }
    
    /// Stops monitoring location updates.
    func stopMonitoring() {
        isMonitoring = false
    }
    
    /// CLLocationManagerDelegate method: Called when location updates are available.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isMonitoring, let location = locations.last else { return }
        
        let now = Date()
        if now.timeIntervalSince(lastUpdateTime) >= updateInterval && shouldUpdateLocation(newLocation: location) {
            lastUpdateTime = now
            lastLocation = location
            
            print("Location updated: \(location.coordinate)")
            for listener in listeners {
                listener(location)
            }
        }
    }
    
    /// Determines if the new location is significantly different from the last one.
    private func shouldUpdateLocation(newLocation: CLLocation) -> Bool {
        guard let lastLocation = lastLocation else { return true }
        let distanceThreshold: CLLocationDistance = 10 // Only update if moved by more than 10 meters.
        return lastLocation.distance(from: newLocation) > distanceThreshold
    }
    
    /// CLLocationManagerDelegate method: Called if an error occurs.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }
}
