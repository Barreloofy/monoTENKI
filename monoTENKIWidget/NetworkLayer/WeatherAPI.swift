//
// WeatherAPI.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 1:06 PM
//

import Foundation

enum WeatherAPI {
  enum Service: URLProvider {
    case geo(query: Coordinate)
    case weather(query: String)
  }

  static func fetchWeather(for query: Coordinate) async throws -> WeatherAPIWeather {
    let location = try await fetchPosition(for: query)

    let client = try HTTPClient(
      url: Service.weather(query: location).provideURL(),
      decoder: WeatherAPIWeather.decoder)

    return try await client.fetch()
  }

  private static func fetchPosition(for query: Coordinate) async throws -> String {
    let client = try HTTPClient(url: Service.geo(query: query).provideURL())
    let locations: WeatherAPILocations = try await client.fetch()

    guard
      let location = locations.first
    else { throw UnwrappingError(type: WeatherAPILocations.self)}

    return "id:\(location.id)"
  }
}


extension WeatherAPI.Service {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "WeatherAPI.comAPIKey") as! String
  }

  func provideURL() throws -> URL {
    let service: String
    let query: String

    switch self {
    case .geo(let value):
      service = "search"
      query = value.description

    case .weather(let value):
      service = "forecast"
      query = value
    }

    return try constructURL(
      host: "api.weatherapi.com",
      path: "/v1/\(service).json",
      queryItems: [
        "key": apiKey,
        "q": query,
        "days": "1",
      ])
  }

  func provideURLs(query: String) throws -> [String : URL] {
    throw URLError(.badURL)
  }
}
