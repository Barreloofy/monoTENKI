//
//  Today.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 1:58 PM.
//

import SwiftUI

struct Today: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  @State private var presentDetails = false

  let current: CurrentWeather

  var body: some View {
    VStack {
      VStack(spacing: 50) {
        WeatherIcon(
          name: current.condition,
          isDay: current.isDay,
          size: horizontalSizeClass == .compact ? 250 : 375)

        TemperatureView(current.temperatures.celsius)
          .primaryFont()

        HStack {
          TemperatureView(
            "L",
            current.temperatures.celsiusLow,
            accessibilityText: "Low")

          TemperatureView(
            "H",
            current.temperatures.celsiusHigh,
            accessibilityText: "High")
        }
        .primaryFontSecondary()

        Text(current.condition)
          .primaryFontSecondary()
          .lineLimit(nil)
      }
      .containerRelativeFrame(.horizontal)
      .contentShape(Rectangle())
      .onTapGesture { presentDetails = true }
      .enabled(!presentDetails)

      CurrentDetailPage(present: $presentDetails, weather: current)
    }
    .animation(reduceMotion ? nil : .easeInOut.speed(0.5), value: presentDetails)
    .sensoryFeedback(.impact, trigger: presentDetails)
  }
}
