//
// AccuWeatherLocation.swift
// monoTENKI
//
// Created by Barreloofy on 4/18/25 at 3:06 PM.
//

import Foundation

typealias AccuWeatherLocations = [AccuWeatherLocation]

/// The model produced by decoding AccuWeather/geo or AccuWeather/search.
struct AccuWeatherLocation: Decodable {
  let key: String
  let localizedName: String
  let country: Country
  let administrativeArea: Area
  let geoPosition: Coordinate

  struct Country: Decodable {
    let localizedName: String
  }

  struct Area: Decodable {
    let localizedName: String
  }

  struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
  }
}


extension AccuWeatherLocation {
  static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromPascalCase

    return decoder
  }()
}
