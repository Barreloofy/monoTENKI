//
//  WeatherAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 3:14 PM.
//

import Foundation
import CoreLocation

/// Weather aggregate model.
@MainActor
@Observable
final class WeatherAggregate {
  enum State: Equatable {
    case loading
    case loaded(currentWeather: CurrentWeather, hourForecast: Hours, dayForecast: Days)
    case error
  }
  
  /// The current state of the aggregate.
  private(set) var state = State.loading

  /// Update the aggregate based on `location` and `source`.
  /// - Parameters:
  ///   - location: <#location description#>
  ///   - source: <#source description#>
  func getWeather(for location: CLLocationCoordinate2D, from source: APISource) async {
    print(location)

    do {
      let weather: any Weather

      switch source {
      case .weatherAPI:
        weather = try await WeatherAPI.fetchWeather(for: location)
      case .accuWeather:
        weather = try await AccuWeather.fetchWeather(for: location)
      }

      async let currentWeather = weather.createCurrentWeather()
      async let hourForecast = weather.createHourForecast()
      async let dayForecast = weather.createDayForecast()

      state = try await .loaded(
        currentWeather: currentWeather,
        hourForecast: hourForecast,
        dayForecast: dayForecast)
    } catch {
      state = .error
    }
  }
}
