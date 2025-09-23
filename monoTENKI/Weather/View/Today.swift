//
//  Today.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 1:58 PM.
//

import SwiftUI

struct Today: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @State private var presentDetails = false

  let current: CurrentWeather

  var body: some View {
    VStack {
      VStack {
        WeatherSymbol(name: current.condition, isDay: current.isDay)
          .layoutPriority(horizontalSizeClass == .regular ? 0 : -1)

        VStack(spacing: 50) {
          TemperatureView(current.temperatures.celsius)
            .headlineFont()
            .layoutPriority(2)

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
          .subheadlineFont()
          .layoutPriority(1)

          Text(current.condition)
            .subheadlineFont()
            .lineLimit(nil)
            .layoutPriority(1)
        }
      }
      .visible(!presentDetails)

      CurrentDetailPage(weather: current)
        .visible(presentDetails)
    }
    .padding(.bottom)
    .containerRelativeFrame([.vertical, .horizontal], alignment: presentDetails ? .center : .top)
    .contentShape(Rectangle())
    .onTapGesture { presentDetails() }
    .animating(presentDetails, with: .easeInOut(duration: 1))
    .sensoryFeedback(.impact, trigger: presentDetails)
  }
}
