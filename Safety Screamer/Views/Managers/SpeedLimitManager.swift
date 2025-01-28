//
//  SpeedLimitManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/16/25.
//
//  Description:
//  Uses the HERE speed limit API to convert user coordinates into
//  the speed limit of the road that they're on. Speed limit automatically
//  gets updated in real time whenever the location changes.
//

import CoreLocation
import SwiftUI

class SpeedLimitManager: NSObject, ObservableObject {
    @AppStorage("usingMetric") private var usingMetric = false
    private let apiKey = "CgMTXMFNH0T6MPtKm_MWnxM2D07qH36r4KoPwIVMwlE"

    @Published var speedLimit: Int? // Speed limit in the area (in the unit provided by API)
    @Published var speedLimitUnit: String? // Unit of the speed limit (e.g., M for mph, K for km/h)
    
    let radius: Int = 500 // The radius that the API will check for speed limits (Meters)

    override init() {
        super.init()

        // Update speed limit when location changes
        LocationManager.shared.addListener { [weak self] location in
            self?.fetchSpeedLimit(for: location.coordinate)
            print("Testing location manager. Here are the coords: ")
            print(location.coordinate)
        }
    }

    public func getSpeedLimit() -> Int {
        guard let speedLimit = speedLimit else { return 0 }
        return usingMetric ? convertToMetric(speedLimit, unit: speedLimitUnit) : convertToImperial(speedLimit, unit: speedLimitUnit)
    }

    private func convertToMetric(_ speed: Int, unit: String?) -> Int {
        if unit == "M" { // Convert mph to km/h
            return Int(Double(speed) * 1.60934)
        }
        return speed // Already in km/h
    }

    private func convertToImperial(_ speed: Int, unit: String?) -> Int {
        
        if unit == "K" { // Convert km/h to mph
            return Int(Double(speed) / 1.60934)
        }
        return speed // Already in mph
    }

    public func fetchSpeedLimit(for coordinate: CLLocationCoordinate2D) {
        // Validate URL for GET request
        guard let url = URL(string: "https://smap.hereapi.com/v8/maps/attributes?layers=SPEED_LIMITS_FC4&in=proximity:\(coordinate.latitude),\(coordinate.longitude);r=\(radius)&apiKey=\(apiKey)") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching speed limit: \(error.localizedDescription)")
                return
            }

            // Validate data
            guard let data = data else {
                print("No data received from API")
                return
            }

            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let geometries = json["geometries"] as? [[String: Any]],
                   let firstGeometry = geometries.first,
                   let attributes = firstGeometry["attributes"] as? [String: Any] {

                    // Extract speed limits and handle null cases
                    let fromSpeedLimit = attributes["FROM_REF_SPEED_LIMIT"] as? String
                    let toSpeedLimit = attributes["TO_REF_SPEED_LIMIT"] as? String
                    let unit = attributes["SPEED_LIMIT_UNIT"] as? String

                    // Convert speed limit strings to integers safely
                    let speedLimitValue = Int(fromSpeedLimit ?? toSpeedLimit ?? "0") ?? 0

                    DispatchQueue.main.async {
                        self?.speedLimit = speedLimitValue
                        self?.speedLimitUnit = unit
                        print("Success! Speed limit: \(speedLimitValue) \(unit ?? "")")
                    }
                } else {
                    print("Failed to parse API response")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
