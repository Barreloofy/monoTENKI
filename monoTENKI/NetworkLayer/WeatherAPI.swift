//
//  WeatherAPI.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 5:44 PM.
//

import CoreLocation

/// Concrete interface for WeatherAPI.com.
@MainActor
enum WeatherAPI {
  enum Service: URLProvider {
    case weather(query: String)
    case search(query: String)
  }

  static func fetchWeather(for query: Coordinate) async throws -> WeatherAPIWeather {
    let location = try await fetchPosition(for: query)

    let client = try HTTPClient(
      url: Service.weather(query: location).provideURL(),
      decoder: WeatherAPIWeather.decoder)

    return try await client.fetch()
  }

  static func fetchSearch(for query: String) async throws -> Locations {
    let client = try HTTPClient(url: Service.search(query: query).provideURL())
    let locations: WeatherAPILocations = try await client.fetch()

    return locations.map { location in
      Location(
        name: location.name,
        country: location.country,
        coordinate: .init(latitude: location.lat, longitude: location.lon))
    }
  }

  private static func fetchPosition(for query: Coordinate) async throws -> String {
    let client = try HTTPClient(url: Service.search(query: query.stringRepresentation).provideURL())
    let locations: WeatherAPILocations = try await client.fetch()

    guard let location = locations.first else { throw UnwrappingError(type: WeatherAPILocations.self) }

    return "id:\(location.id)"
  }
}
