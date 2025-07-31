//
//  CurrentDetailPage.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/15/25 at 12:37 PM.
//

import SwiftUI

struct CurrentDetailPage: View {
  let weather: CurrentWeather

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      DetailSection(title: "Temperatures") {
        TemperatureView("Now", weather.temperatures.celsius)

        TemperatureView("Feels Like", weather.temperatures.feelsLikeCelsius)

        TemperatureView("High", weather.temperatures.celsiusHigh)

        TemperatureView("Low", weather.temperatures.celsiusLow)

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
          .accessibilityLabel(weather.wind.direction.formatted(.windDirectionWide))

        SpeedView("Speed", weather.wind.speedKilometersPerHour)

        SpeedView("Gust", weather.wind.gustKilometersPerHour)
      }
    }
    .offset(y: -50)
  }
}
