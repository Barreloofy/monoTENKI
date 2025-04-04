//
//  Today.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 1:58 PM.
//

import SwiftUI

struct Today: View {
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(\.colorScheme) private var colorScheme

  let weatherDetails: WeatherModel.CurrentWeather

  var body: some View {
    ZStack {
      Color(colorScheme == .light ? .white : .black)
      VStack {
        Image(systemName: weatherDetails.condition.presentIcon(isDay: weatherDetails.isDay))
          .resizable()
          .scaledToFit()
          .fontWeight(.regular)
          .frame(width: 250)
          .padding(.bottom, 50)

        Group {
          Text(weatherDetails.temperatures.temperatureCelsius.temperatureFormatter(measurementSystem))
            .font(.system(size: 60))
          HStack {
            Text("L: \(weatherDetails.temperatures.temperatureCelsiusLow.temperatureFormatter(measurementSystem))")
            Text("H: \(weatherDetails.temperatures.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))")
          }
          .font(.system(size: 30))
        }
        .padding(.bottom, 25)

        Text(weatherDetails.condition)
          .font(.title)

        Spacer()
      }
    }
  }
}
