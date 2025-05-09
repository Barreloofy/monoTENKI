//
//  Today.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 1:58 PM.
//

import SwiftUI

struct Today: View {
  @Environment(\.measurementSystem) private var measurementSystem

  @State private var presentDetails = false

  let current: CurrentWeather

  var body: some View {
    VStack(spacing: 50) {
      Image(systemName: current.condition.presentIcon(isDay: current.isDay))
        .styled(size: 250)

      Text(current.temperatures.temperatureCelsius.temperatureFormatter(measurementSystem))
        .font(.system(size: 60))

      HStack {
        Text("L \(current.temperatures.temperatureCelsiusLow.temperatureFormatter(measurementSystem))")
        Text("H \(current.temperatures.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))")
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
    .detailPageCurrent(present: $presentDetails, current: current)
    .animation(.easeInOut.speed(0.5), value: presentDetails)
  }
}
