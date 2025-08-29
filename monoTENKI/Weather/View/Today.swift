//
//  Today.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 1:58 PM.
//

import SwiftUI

struct Today: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @State private var presentDetails = false

  let current: CurrentWeather

  var body: some View {
    VStack {
      VStack(spacing: horizontalSizeClass == .regular ? 75 : 50) {
        WeatherSymbol(name: current.condition, isDay: current.isDay)

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
        .secondaryFont()

        Text(current.condition)
          .secondaryFont()
          .lineLimit(nil)
      }
      .enabled(!presentDetails)
      .padding(.vertical)

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
