//
//  Today.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 1:58 PM.
//

import SwiftUI

struct Today: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem

  let weatherDetails: CurrentWeather

  var body: some View {
    ZStack {
      Color(colorScheme.background)
      VStack(spacing: 50) {
        Image(systemName: weatherDetails.condition.presentIcon(isDay: weatherDetails.isDay))
          .styled(size: 250)

        Text(weatherDetails.temperatures.temperatureCelsius.temperatureFormatter(measurementSystem))
          .font(.system(size: 60))

        HStack {
          Text("L: \(weatherDetails.temperatures.temperatureCelsiusLow.temperatureFormatter(measurementSystem))")
          Text("H: \(weatherDetails.temperatures.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))")
        }
        .font(.system(size: 30))

        Text(weatherDetails.condition)
          .font(.title)

        Spacer()
      }
    }
  }
}
