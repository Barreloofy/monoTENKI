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

  var state = State.loading

  func getWeather(for location: String, from source: APISource) async {
    do {
      let weather: Weather

      switch source {
      case .weatherApi:
        weather = try await WeatherAPI.fetchWeather(for: location)
      case .accuWeather:
        weather = try await AccuWeather.fetchWeather(for: location)
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
