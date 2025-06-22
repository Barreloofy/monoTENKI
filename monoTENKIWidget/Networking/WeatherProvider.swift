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

      let weatherAPIResponse: WeatherAPIWeather = try await client.fetch()
      let isDay = weatherAPIResponse.current.isDay == 1 ? true : false

      return Weather(
        condition: weatherAPIResponse.current.condition.text,
        isDay: isDay,
        temperatureCelsius: weatherAPIResponse.current.tempC)
    case .accuWeather:
      let client = try HTTPClient(
        url: AccuWeather.weather(query: location).provideURL(),
        decoder: AccuWeatherWeather.decoder)

      let accuWeatherResponse: [AccuWeatherWeather] = try await client.fetch()
      let current = accuWeatherResponse.first!

      return Weather(
        condition: current.weatherText,
        isDay: current.isDayTime,
        temperatureCelsius: current.temperature.metric.value)
    }
  }
}
