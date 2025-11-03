//
// WeatherAPILocation.swift
// monoTENKI
//
// Created by Barreloofy on 3/18/25 at 12:47 AM.
//

typealias WeatherAPILocations = [WeatherAPILocation]

/// The model produced by decoding WeatherAPI/search.
struct WeatherAPILocation: Decodable {
  let id: Int
  let name: String
  let country: String
  let lat: Double
  let lon: Double
}
