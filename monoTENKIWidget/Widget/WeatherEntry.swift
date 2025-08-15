//
// WeatherEntry.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:18 PM
//

import WidgetKit

struct WeatherEntry: TimelineEntry {
  let date: Date
  let weather: Weather
}


extension WeatherEntry {
  static let placeholder = WeatherEntry(
    date: .now,
    weather: Weather(
      condition: "Clear",
      isDay: true,
      temperatureCelsius: 22,
      precipitationChance: 0))
}
