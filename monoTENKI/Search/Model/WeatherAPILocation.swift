//
//  WeatherAPILocation.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 12:47 AM.
//

typealias WeatherAPILocations = [WeatherAPILocation]
/// The Model used as the decoded object for location data
struct WeatherAPILocation: Codable, Identifiable, Equatable {
  let id: Int
  let name: String
  let country: String
  let lat: Double
  let lon: Double
}

// MARK: - Convenience properties
extension WeatherAPILocation {
  var coordinates: String {
    "\(lat) \(lon)"
  }
}
