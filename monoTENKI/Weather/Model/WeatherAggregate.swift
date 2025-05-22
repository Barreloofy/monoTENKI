//
//  WeatherAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 3:14 PM.
//

import Foundation
/// Weather aggregate model.
@MainActor
@Observable
class WeatherAggregate {
  enum State: Equatable {
    case loading
    case loaded(currentWeather: CurrentWeather, hourForecast: Hours, dayForecast: Days)
    case error
  }

  var state: State = .loading

  func getWeather(for location: String, with source: APISource) async {
    do {
      let weather: Weather

      switch source {
      case .weatherApi:
        weather = try await WeatherAPI.weather(query: location).fetchWeather()
      case .accuWeather:
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
