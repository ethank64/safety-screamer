//
//  SpeedLimitManager.swift
//  Safety Screamer
//
//  Created by Ethan Knotts on 1/16/25.
//

import CoreLocation
import SwiftUI

class SpeedLimitManager: NSObject, ObservableObject {
    private let apiKey = "CgMTXMFNH0T6MPtKm_MWnxM2D07qH36r4KoPwIVMwlE"

    @Published var speedLimit: Int? // Speed limit in the area (in the unit provided by API)
    @Published var speedLimitUnit: String? // Unit of the speed limit (e.g., M for mph, K for km/h)
    
    

    override init() {
        super.init()
        
        // Update speed limit when location changes
        // TODO: make it update every so often instead of every time the location changes
        LocationManager.shared.addListener { [weak self] location in
            self?.fetchSpeedLimit(for: location.coordinate)
        }
    }

    public func fetchSpeedLimit(for coordinate: CLLocationCoordinate2D) {
        // Validate URL for GET request
        guard let url = URL(string: "https://smap.hereapi.com/v8/maps/attributes?layers=SPEED_LIMITS_FC4&in=proximity:\(coordinate.latitude),\(coordinate.longitude);r=50&apiKey=\(apiKey)") else {
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
                   let attributes = geometries.first?["attributes"] as? [String: Any] {

                    let fromSpeedLimit = attributes["FROM_REF_SPEED_LIMIT"] as? String
                    let toSpeedLimit = attributes["TO_REF_SPEED_LIMIT"] as? String
                    let unit = attributes["SPEED_LIMIT_UNIT"] as? String

                    DispatchQueue.main.async {
                        self?.speedLimit = Int(fromSpeedLimit ?? toSpeedLimit ?? "0")
                        self?.speedLimitUnit = unit
                        print("Success! Speed limit: ")
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
