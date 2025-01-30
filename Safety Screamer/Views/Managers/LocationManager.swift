import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    // Instance of Core Location's class
    private let coreLocationManager = CLLocationManager()
    private var listeners: [(CLLocation) -> Void] = [] // Store multiple closures
    private var isMonitoring: Bool = false
    
    private var lastLocation: CLLocation?
    private var lastUpdateTime: Date = Date.distantPast
    private let updateInterval: TimeInterval = 3 // Only update every 3 seconds

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
    
    func getCurrentCoordinates() -> CLLocationCoordinate2D? {
        return coreLocationManager.location?.coordinate
    }

    func addListener(_ listener: @escaping (CLLocation) -> Void) {
        listeners.append(listener)
    }
    
    func startMonitoring() {
        isMonitoring = true
    }
    
    func stopMonitoring() {
        isMonitoring = false
    }

    // Built-in method that's part of CLLocationManager
    // Automatically updates the listeners with the new location value
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isMonitoring, let location = locations.last else { return }
        
        let now = Date()
        if now.timeIntervalSince(lastUpdateTime) >= updateInterval && shouldUpdateLocation(newLocation: location) {
            lastUpdateTime = now
            lastLocation = location
            
            print("Location updated")
            for listener in listeners {
                listener(location)
            }
        }
    }
    
    private func shouldUpdateLocation(newLocation: CLLocation) -> Bool {
        guard let lastLocation = lastLocation else { return true }
        let distanceThreshold: CLLocationDistance = 10 // Only update if moved by 10 meters
        return lastLocation.distance(from: newLocation) > distanceThreshold
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
