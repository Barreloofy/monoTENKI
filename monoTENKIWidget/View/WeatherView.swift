//
// WeatherView.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:37 PM
//

import SwiftUI

struct WeatherView: View {
  @Environment(\.locale) private var locale

  let weather: Weather

  var body: some View {
    VStack {
      HStack {
        WeatherSymbol(
          name: weather.condition,
          isDay: weather.isDay)

        TemperatureView(
          weather.temperatureCelsius,
          accessibilityText: "Now")
      }
      .font(.largeTitle)

      RainView(
        precipitationChance: weather.precipitationChance)
    }
    .transformEnvironment(\.measurementSystemInUse) { measurementSystem in
      switch locale.measurementSystem {
      case .metric:
        measurementSystem = .metric
      case .us, .uk:
        measurementSystem = .imperial
      default:
        measurementSystem = .metric
      }
    }
  }
}
