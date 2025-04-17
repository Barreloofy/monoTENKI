//
//  HourForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 4:33 PM.
//

import SwiftUI

struct HourForecast: View {
  @Environment(\.measurementSystem) private var measurementSystem

  let hours: Hours

  var body: some View {
    VStack {
      ForEach(hours, id: \.time) { hour in
        ZStack {
          AlignedHStack(alignment: .leading) {
            Text(hour.time.formatted(.timeZoneNeutral))
          }

          Image(systemName: hour.condition.presentIcon(isDay: hour.isDay))
            .styled(size: 30)

          AlignedHStack(alignment: .trailing) {
            Text(hour.temperatureCelsius.temperatureFormatter(measurementSystem))
          }
        }
        .font(.title2)
      }
      Spacer()
    }
  }
}
