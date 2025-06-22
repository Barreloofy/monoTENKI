//
// WeatherView.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:37 PM
//

import SwiftUI

struct WeatherView: View {
  let entry: WeatherEntry

  var body: some View {
    HStack {
      WeatherIcon(name: entry.weather.condition, isDay: entry.weather.isDay, size: 75)
      TemperatureView(entry.weather.temperatureCelsius)
        .font(.system(.title, design: .monospaced, weight: .bold))
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
  }
}
