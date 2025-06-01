//
//  Today.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 1:58 PM.
//

import SwiftUI

struct Today: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  @State private var presentDetails = false

  let current: CurrentWeather

  var body: some View {
    VStack(spacing: 50) {
      WeatherIcon(
        name: current.condition,
        isDay: current.isDay,
        size: 250)

      TemperatureView(current.temperatures.temperatureCelsius)
        .font(.system(size: 60))

      HStack {
        TemperatureView(
          "L",
          current.temperatures.temperatureCelsiusLow,
          accessibilityText: "Low")
        TemperatureView(
          "H",
          current.temperatures.temperatureCelsiusHigh,
          accessibilityText: "High")
      }
      .font(.system(size: 30))

      Text(current.condition)
        .font(.title)
        .multilineTextAlignment(.center)

      Spacer()
    }
    .containerRelativeFrame([.vertical, .horizontal])
    .contentShape(Rectangle())
    .onTapGesture { presentDetails = true }
    .accessibilityHidden(presentDetails)
    .detailPageCurrent(present: $presentDetails, current: current)
    .animation(reduceMotion ? nil : .easeInOut.speed(0.5), value: presentDetails)
    .sensoryFeedback(.impact, trigger: presentDetails)
  }
}
