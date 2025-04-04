//
//  HourForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 4:33 PM.
//

import SwiftUI

struct HourForecast: View {
  @Environment(\.measurementSystem) private var measurementSystem

  let hours: Weather.Hours

  var body: some View {
    List(hours, id: \.time) { hour in
      ZStack {
        AlignedHStack(alignment: .leading) {
          Text(hour.time.formatted(.timeZoneNeutral))
        }

        Image(systemName: hour.condition.text.presentIcon(isDay: hour.isDay))
          .resizable()
          .scaledToFit()
          .fontWeight(.regular)
          .frame(width: 30)

        AlignedHStack(alignment: .trailing) {
          Text(hour.temperatureCelsius.temperatureFormatter(measurementSystem))
        }
      }
      .listRowSeparator(.hidden)
    }
    .font(.title2)
    .listStyle(.plain)
    .scrollIndicators(.hidden)
  }
}
