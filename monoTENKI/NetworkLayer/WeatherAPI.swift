//
//  WeatherAPI.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 5:44 PM.
//

import Foundation
/// Concrete interface for WeatherAPI.com
enum WeatherAPI: URLProvider {
  case weather(query: String)
  case search(query: String)

  func fetchWeather() async throws -> WeatherAPIWeather {
    let client = try HTTPClient(
      url: provideURL(),
      decoder: WeatherAPIWeather.decoder)

    return try await client.fetch()
  }

  func fetchSearch() async throws -> Locations {
    let client = try HTTPClient(url: provideURL())

    let weatherApiLocations = try await client.fetch() as WeatherAPILocations

    return weatherApiLocations.compactMap { location in
      Location(
        source: .WeatherAPI,
        id: location.id,
        name: location.name,
        country: location.country,
        latitude: location.longitude,
        longitude: location.latitude)
    }
  }
}
