//
// WeatherEntry.swift
// monoTENKI
//
// Created by Barreloofy on 11/5/25 at 8:46 PM
//

import WidgetKit

struct WeatherEntry: TimelineEntry {
  let date = Date.now.addingTimeInterval(900)
  let weather: Weather?
}


extension WeatherEntry {
  /// Provides an empty entry, with no weather values.
  static let placeholder = WeatherEntry(weather: nil)
  
  /// Provides a preview entry, with preview values.
  static let preview = WeatherEntry(
    weather: .init(
      condition: "Clear",
      isDay: true,
      temperatureCelsius: 22,
      precipitationChance: 0))
}
