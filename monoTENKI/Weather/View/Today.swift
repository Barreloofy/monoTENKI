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

  let weather: CurrentWeather

  var body: some View {
    ZStack {
      Color(colorScheme.background)
      VStack(spacing: 50) {
        Image(systemName: weather.condition.presentIcon(isDay: weather.isDay))
          .styled(size: 250)

        Text(weather.temperatures.temperatureCelsius.temperatureFormatter(measurementSystem))
          .font(.system(size: 60))

        HStack {
          Text("L \(weather.temperatures.temperatureCelsiusLow.temperatureFormatter(measurementSystem))")
          Text("H \(weather.temperatures.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))")
        }
        .font(.system(size: 30))

        Text(weather.condition)
          .font(.title)
          .multilineTextAlignment(.center)

        Spacer()
      }
    }
  }
}
