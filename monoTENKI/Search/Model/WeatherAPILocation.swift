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
  let latitude: Double
  let longitude: Double

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case country
    case latitude = "lat"
    case longitude = "lon"
  }
}

// MARK: - Convenience properties
extension WeatherAPILocation {
  var coordinates: String {
    "\(latitude) \(longitude)"
  }
}
