//
// WeatherAggregate.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 5:19 PM
//

import Foundation

enum WeatherAggregate {
  case weatherAPI
  case accuWeather

  func fetch(for query: String) async throws -> Weather {
    switch self {
    case .weatherAPI:
      let client = try HTTPClient(url: WeatherAPI.geo(query: query).provideURL())
      let locations: WeatherAPILocations = try await client.fetch()
      
      guard let location = locations.first else {
        throw DecodingError.valueNotFound(
          WeatherAPILocations.self,
          .init(codingPath: [], debugDescription: "Nil found 'locations.first'"))
      }
      let locationID = "id:\(location.id)"

      return try await fetchWeather(for: locationID)

    case .accuWeather:
      let client = try HTTPClient(
        url: AccuWeather.geo(query: query).provideURL(),
        decoder: AccuWeatherComposite.decoder)

      let location: AccuWeatherLocation = try await client.fetch()

      return try await fetchWeather(for: location.key)
    }
  }

  private func fetchWeather(for location: String) async throws -> Weather {
    switch self {
    case .weatherAPI:
      let client = try HTTPClient(
        url: WeatherAPI.weather(query: location).provideURL(),
        decoder: WeatherAPIWeather.decoder)

      let weather: WeatherAPIWeather = try await client.fetch()

      return try weather.create()
      
    case .accuWeather:
      let urlDictionary = try AccuWeather.weather(query: location).provideURLs()
      guard let currentURL = urlDictionary["current"],
            let hourURL = urlDictionary["hour"]
      else { throw URLError(.badURL) }

      let currentClient = HTTPClient(
        url: currentURL,
        decoder: AccuWeatherComposite.decoder)
      async let currentWeather: [AccuWeatherCurrent] = currentClient.fetch()

      let hourClient = HTTPClient(
        url: hourURL,
        decoder: AccuWeatherComposite.decoder)
      async let hourWeather: [AccuWeatherHour] = hourClient.fetch()

      return try await AccuWeatherComposite(current: currentWeather, hours: hourWeather).create()
    }
  }
}
