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
      VStack(spacing: horizontalSizeClass == .compact ? 50 : 100) {
        WeatherIcon(
          name: current.condition,
          isDay: current.isDay,
          usage: .primary)

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
      .enabled(!presentDetails)

      CurrentDetailPage(weather: current)
        .enabled(presentDetails)
    }
    .containerRelativeFrame([.vertical, .horizontal], alignment: presentDetails ? .center : .top)
    .contentShape(Rectangle())
    .onTapGesture { presentDetails() }
    .animation(reduceMotion ? nil : .easeInOut(duration: 0.75), value: presentDetails)
    .sensoryFeedback(.impact, trigger: presentDetails)
  }
}
