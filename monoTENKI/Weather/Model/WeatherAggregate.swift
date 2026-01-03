//
//  WeatherAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 3:14 PM.
//

import CoreLocation

/// An aggregate that manages weather as a finite state machine.
///
/// The aggregate can be in three distinct states:
///   - `loading`: The **transient** state of a cycle.
///   - `loaded`: The **solid** state of a successful transition.
///   - `error`: The **solid** state of a failed transition.
@Observable
final class WeatherAggregate {
  /// The possible states of the aggregate.
  enum State: Equatable {
    /// The transient state of a cycle.
    case loading

    /// The solid state of a successful transition.
    case loaded(
      currentWeather: CurrentWeather,
      hourForecast: Hours,
      dayForecast: Days)

    /// The solid state of a failed transition.
    case error
  }

  /// The current state of the aggregate.
  private var state = State.loading

  /// Update the aggregate based on `location` and `source`.
  /// - Parameters:
  ///   - location: The location as **WGS 84** coordinate to query the weather for.
  ///   - source: The Weather Service to use for the query.
  ///   - resetState: Pass `true` to go through a complete cycle, on `false` transition from Initial state to final state.
  func weather(for location: Coordinate, from source: APISource, resetState: Bool = false) async {
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

  /// Get the current state of the aggregate.
  ///
  /// - Note: Don’t call this method directly, instead call the instance as a function.
  ///
  /// - Returns: The current state of the aggregate.
  func callAsFunction() -> WeatherAggregate.State {
    state
  }
}
