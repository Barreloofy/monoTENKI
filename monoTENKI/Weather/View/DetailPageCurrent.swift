//
//  DetailPageCurrent.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/15/25 at 12:37 PM.
//

import SwiftUI

struct DetailPageCurrent: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

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
                TemperatureView("Now", weather.temperatures.temperatureCelsius)

                TemperatureView("Feels Like", weather.temperatures.feelsLikeCelsius)

                TemperatureView("High", weather.temperatures.temperatureCelsiusHigh)

                TemperatureView("Low", weather.temperatures.temperatureCelsiusLow)

                Text("Humidity \(weather.temperatures.humidity.formatted(.percent))")
              }

              DetailSection(title: "Precipitation") {
                Text("Chance \(weather.precipitation.chance.formatted(.percent))")

                PrecipitationView("Rate", weather.precipitation.rateMillimeter)

                PrecipitationView("Total", weather.precipitation.totalMillimeter)

                Text("Type \(weather.precipitation.type)")
              }

              DetailSection(title: "Wind") {
                Text("Direction \(weather.wind.direction)")
                  .accessibilityLabel(weather.wind.direction.windDirectionWide())

                SpeedView("Speed", weather.wind.speedKilometersPerHour)

                SpeedView("Gust", weather.wind.gustKilometersPerHour)
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
