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
          .layoutPriority(horizontalSizeClass == .regular ? 1 : 0)

        VStack(spacing: 50) {
          TemperatureView(current.temperatures.celsius)
            .headlineFont()

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

          Text(current.condition)
            .subheadlineFont()
            .lineLimit(nil)
        }
        .layoutPriority(1)
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


#Preview {
  let current = CurrentWeather(
    location: "London",
    isDay: true,
    condition: "Clear",
    temperatures: .init(
      celsius: 16,
      celsiusLow: 9,
      celsiusHigh: 21,
      feelsLikeCelsius: 15,
      humidity: 62),
    precipitation: .init(
      chance: 10,
      rateMillimeter: 1,
      totalMillimeter: 1,
      type: "Rain"),
    wind: .init(
      direction: "NSW",
      speedKilometersPerHour: 14,
      gustKilometersPerHour: 27))

  Today(current: current)
    .configureApp()
}
