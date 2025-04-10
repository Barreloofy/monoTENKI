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

  var state: State = .loading

  func getWeather(for location: String) async {
    do {
      let httpClient = HTTPClient(
        urlProvider: WeatherAPI.weather(location),
        decoder: WeatherAPIWeather.decoder)

      let weather: WeatherAPIWeather = try await httpClient.fetch()
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
