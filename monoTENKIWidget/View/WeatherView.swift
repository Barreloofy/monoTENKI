//
// WeatherView.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:37 PM
//

import SwiftUI

struct WeatherView: View {
  @Environment(\.locale) private var locale

  let entry: WeatherEntry

  var body: some View {
    VStack {
      HStack(spacing: 0) {
        WeatherIcon(name: entry.weather.condition, isDay: entry.weather.isDay, size: 75)

        TemperatureView(entry.weather.temperatureCelsius, accessibilityText: "Now")
      }
      .font(.system(.title, design: .monospaced, weight: .bold))

      Label(entry.weather.precipitationChance.formatted(.percent), systemImage: "drop.fill")
        .font(.system(.body, design: .monospaced, weight: .bold))
        .accessibilityLabel("Next hour \(entry.weather.precipitationChance.formatted(.percent)) precipitation Chance")
        .enabled(entry.weather.precipitationChance >= 33)
    }
    .lineLimit(1)
    .minimumScaleFactor(0.5)
    .transformEnvironment(\.measurementSystem) { measurementSystem in
      switch locale.measurementSystem {
      case .metric: measurementSystem = .metric
      default: measurementSystem = .imperial
      }
    }
  }
}
