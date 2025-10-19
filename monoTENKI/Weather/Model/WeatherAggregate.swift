//
//  WeatherAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 3:14 PM.
//

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
  private var state = State.loading

  /// Update the aggregate based on `location` and `source`.
  /// - Parameters:
  ///   - location: The location as WGS 84 coordinate to query the weather for.
  ///   - source: The Weather Service to use for the query.
  ///   - resetState: Pass `true` to go through a complete state cycle instead of transitional.
  func getWeather(for location: CLLocationCoordinate2D, from source: APISource, resetState: Bool = false) async {
    do {
      if resetState { state = .loading }

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

  /// Get the current state of the `WeatherAggregate` instance you call this method on.
  ///
  /// - Note: Don’t call this method directly. call the instance as a function instead.
  ///
  /// - Returns: The current state of the `WeatherAggregate` instance.
  func callAsFunction() -> WeatherAggregate.State {
    state
  }
}
