//
//  WeatherAPI.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 5:44 PM.
//

import Foundation
/// Concrete interface for WeatherAPI.com.
enum WeatherAPI: URLProvider {
  case weather(query: String)
  case search(query: String)

  var query: String {
    switch self {
    case .weather(let query), .search(let query): query
    }
  }

  func fetchWeather() async throws -> WeatherAPIWeather {
    let locations: WeatherAPILocations = try await HTTPClient(url: WeatherAPI.search(query: query).provideURL()).fetch()
    let locationID = "id:\(locations.first!.id)"

    let client = try HTTPClient(
      url: WeatherAPI.weather(query: "\(locationID)").provideURL(),
      decoder: WeatherAPIWeather.decoder)

    return try await client.fetch()
  }

  func fetchSearch() async throws -> Locations {
    let client = try HTTPClient(url: provideURL())

    let locations: WeatherAPILocations = try await client.fetch()

    return locations.compactMap { location in
      Location(
        name: location.name,
        country: location.country,
        coordinate: .init(latitude: location.lat, longitude: location.lon))
    }
  }
}
