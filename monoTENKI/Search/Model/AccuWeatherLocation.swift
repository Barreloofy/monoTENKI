//
//  AccuWeatherLocation.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/18/25 at 3:06 PM.
//

import Foundation

typealias AccuWeatherLocations = [AccuWeatherLocation]
/// The model produced by decoding 'AccuWeather/locations' JSON response
struct AccuWeatherLocation: Decodable {
  let key: String
  let name: String
  let country: Country
  let area: Area
  let coordinate: Coordinate


  enum CodingKeys: String, CodingKey {
    case key = "Key"
    case name = "LocalizedName"
    case country = "Country"
    case area = "AdministrativeArea"
    case coordinate = "GeoPosition"
  }

  struct Country: Decodable {
    let name: String

    enum CodingKeys: String, CodingKey {
      case name = "LocalizedName"
    }
  }

  struct Area: Decodable {
    let name: String

    enum CodingKeys: String, CodingKey {
      case name = "LocalizedName"
    }
  }

  struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
      case latitude = "Latitude"
      case longitude = "Longitude"
    }
  }
}
