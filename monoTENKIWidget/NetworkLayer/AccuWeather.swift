//
// AccuWeather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 3:12 PM
//

import Foundation

enum AccuWeather {
  enum Service: URLProvider {
    case geo(query: String)
    case weather

    static let currentKey = "current"
    static let hourKey = "hour"
  }

  static func fetchWeather(for query: String) async throws -> AccuWeatherComposite {
    let location = try await fetchPosition(for: query)
    let urlDictionary = try Service.weather.provideURLs(query: location)

    guard
      let currentURL = urlDictionary[Service.currentKey],
      let hourURL = urlDictionary[Service.hourKey]
    else { throw URLError(.badURL) }

    let currentClient = HTTPClient(
      url: currentURL,
      decoder: AccuWeatherComposite.decoder)
    async let currentWeather: [AccuWeatherCurrent] = try await currentClient.fetch()

    let hourClient = HTTPClient(
      url: hourURL,
      decoder: AccuWeatherComposite.decoder)
    async let hourWeather: [AccuWeatherHour] = try await hourClient.fetch()

    return try await AccuWeatherComposite.init(current: currentWeather, hours: hourWeather)
  }

  private static func fetchPosition(for query: String) async throws -> String {
    let client = try HTTPClient(
      url: Service.geo(query: query).provideURL(),
      decoder: AccuWeatherComposite.decoder)
    let location: AccuWeatherLocation = try await client.fetch()

    return location.key
  }
}


extension AccuWeather.Service {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "AccuWeatherAPIKey") as! String
  }

  func provideURL() throws -> URL {
    switch self {
    case .geo(let query):
      try constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/geoposition",
        queryItems: [
          "apikey": apiKey,
          "q": query,
        ])
    case .weather: throw URLError(.badURL)
    }
  }

  func provideURLs(query: String = "") throws -> [String : URL] {
    switch self {
    case .geo:
      throw URLError(.badURL)
    case .weather:
      let currentURL = try constructURL(
        host: "dataservice.accuweather.com",
        path: "/currentconditions/v1/\(query)",
        queryItems: [
          "apikey": apiKey,
        ])

      let hourURL = try constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/hourly/1hour/\(query)",
        queryItems: [
          "apikey": apiKey,
          "details": "false",
          "metric": "true",
        ])

      return [Self.currentKey: currentURL, Self.hourKey: hourURL]
    }
  }
}
