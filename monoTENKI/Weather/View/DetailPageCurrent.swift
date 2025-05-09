//
//  DetailPageCurrent.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/15/25 at 12:37 PM.
//

import SwiftUI

struct DetailPageCurrent: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem

  @Binding var present: Bool

  let weather: CurrentWeather

  func body(content: Content) -> some View {
    content
      .overlay {
        if present {
          ZStack {
            colorScheme.background
            VStack(alignment: .leading, spacing: 10) {
              DetailSection(title: "Temperatures") {
                Text("Now \(weather.temperatures.temperatureCelsius.temperatureFormatter(measurementSystem))")

                Text("Feels Like \(weather.temperatures.feelsLikeCelsius.temperatureFormatter(measurementSystem))")

                Text("High \(weather.temperatures.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))")

                Text("Low \(weather.temperatures.temperatureCelsiusLow.temperatureFormatter(measurementSystem))")

                Text("Humidity \(weather.temperatures.humidity.formatted(.percent))")
              }

              DetailSection(title: "Precipitation") {
                Text("Chance \(weather.precipitation.chance.formatted(.percent))")

                Text("Rate \(weather.precipitation.rateMillimeter.precipitationFormatter(measurementSystem))")

                Text("Total \(weather.precipitation.totalMillimeter.precipitationFormatter(measurementSystem))")

                Text("Type \(weather.precipitation.type)")
              }

              DetailSection(title: "Wind") {
                Text("Direction \(weather.wind.direction)")

                Text("Speed \(weather.wind.speedKilometersPerHour.SpeedFormatter(measurementSystem))")

                Text("Gust \(weather.wind.gustKilometersPerHour.SpeedFormatter(measurementSystem))")
              }
            }
            .offset(y: -50)
          }
          .onTapGesture { present = false }
        }
      }
  }
}


extension View {
  func detailPageCurrent(
    present: Binding<Bool>,
    current: CurrentWeather) -> some View {
    modifier(
      DetailPageCurrent(
        present: present,
        weather: current))
  }
}
