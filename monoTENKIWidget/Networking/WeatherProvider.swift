//
// WeatherProvider.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 5:19 PM
//

import Foundation

enum WeatherProvider {
  case weatherAPI
  case accuWeather

  func fetch(for location: String) async throws -> Weather {
    switch self {
    case .weatherAPI:
      let client = try HTTPClient(url: WeatherAPI.geo(query: location).provideURL())

      let locations: WeatherAPILocations = try await client.fetch()
      let locationID = "id:\(locations.first!.id)"

      return try await fetchWeather(for: locationID)
    case .accuWeather:
      let client = try HTTPClient(
        url: AccuWeather.geo(query: location).provideURL(),
        decoder: AccuWeatherWeather.decoder)

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

      guard let today = weather.forecast.forecastday.first,
            let hour = today.hour.first(where: { $0.time.compareDateComponent(.hour, with: .now) })
      else {
        throw DecodingError.valueNotFound(
          WeatherAPIWeather.Forecast.self,
          .init(codingPath: [], debugDescription: "Nil was found while unwrapping"))
      }

      let isDay = weather.current.isDay == 1 ? true : false
      let chance = hour.chanceOfRain > hour.chanceOfSnow ? hour.chanceOfRain : hour.chanceOfSnow

      return Weather(
        condition: weather.current.condition.text,
        isDay: isDay,
        temperatureCelsius: weather.current.tempC,
        precipitationChance: chance)

    case .accuWeather:
      let urlDictionary = try AccuWeather.weather(query: location).provideURLs()
      guard let currentURL = urlDictionary["current"],
            let hourURL = urlDictionary["hour"]
      else { throw URLError(.badURL) }

      let currentClient = HTTPClient(
        url: currentURL,
        decoder: AccuWeatherWeather.decoder)
      let currentWeather: [AccuWeatherWeather] = try await currentClient.fetch()

      let hourClient = HTTPClient(
        url: hourURL,
        decoder: AccuWeatherWeather.decoder)
      let hourWeather: [AccuWeatherWeatherHour] = try await hourClient.fetch()

      guard let current = currentWeather.first,
            let hour = hourWeather.first
      else {
        throw DecodingError.valueNotFound(
          (any Sequence).self,
          .init(codingPath: [], debugDescription: "Nil was found while unwrapping"))
      }

      return Weather(
        condition: current.weatherText,
        isDay: current.isDayTime,
        temperatureCelsius: current.temperature.metric.value,
        precipitationChance: hour.precipitationProbability)
    }
  }
}
