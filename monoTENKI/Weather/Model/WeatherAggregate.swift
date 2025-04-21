//
//  WeatherAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 3:14 PM.
//

import Foundation
/// Weather aggregate model
@MainActor
@Observable
class WeatherAggregate {
  enum State {
    case loading
    case loaded(currentWeather: CurrentWeather, hourForecast: Hours, dayForecast: Days)
    case error
  }

  var source: Source = UserDefaults.standard.source(forKey: "source") {
    didSet { UserDefaults.standard.set(source.rawValue, forKey: "source") }
  }
  var state: State = .loading

  func getWeather(for location: String) async {
    guard !location.isEmpty else { return }

    do {
      let weather: Weather

      switch source {
      case .WeatherAPI:
        weather = try await WeatherAPI.weather(query: location).fetchWeather()
      case .AccuWeather:
        weather = try await AccuWeather.weather(query: location).fetchWeather()
      }

      async let currentWeather = weather.createCurrentWeather()
      async let hourForecast = weather.createHourForecast()
      async let dayForecast = weather.createDayForecast()

      state = await .loaded(
        currentWeather: currentWeather,
        hourForecast: hourForecast,
        dayForecast: dayForecast)
    } catch {
      state = .error
    }
  }
}
