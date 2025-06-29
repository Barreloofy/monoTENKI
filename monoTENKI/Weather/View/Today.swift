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
    VStack(spacing: 50) {
      WeatherIcon(
        name: current.condition,
        isDay: current.isDay,
        size: horizontalSizeClass == .compact ? 250 : 375)

      TemperatureView(current.temperatures.celsius)
        .font(.system(size: horizontalSizeClass == .compact ? 60 : 90))

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
      .font(.system(size: horizontalSizeClass == .compact ? 30 : 45))

      Text(current.condition)
        .font(horizontalSizeClass == .compact ? .title : .largeTitle)

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
