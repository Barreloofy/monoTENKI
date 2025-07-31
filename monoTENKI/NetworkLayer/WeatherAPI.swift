//
//  WeatherAPI.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 5:44 PM.
//

import Foundation

/// Concrete interface for WeatherAPI.com.
enum WeatherAPI {
  enum Service: URLProvider {
    case weather(query: String)
    case search(query: String)
  }

  static func fetchWeather(for query: String) async throws -> WeatherAPIWeather {
    let searchClient = try HTTPClient(url: Service.search(query: query).provideURL())
    let locations: WeatherAPILocations = try await searchClient.fetch()

    guard let location = locations.first else {
      throw DecodingError.valueNotFound(
        WeatherAPILocations.self,
        .init(codingPath: [], debugDescription: "Nil found 'locations.first'"))
    }
    let locationID = "id:\(location.id)"

    let weatherClient = try HTTPClient(
      url: Service.weather(query: locationID).provideURL(),
      decoder: WeatherAPIWeather.decoder)

    return try await weatherClient.fetch()
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
}
