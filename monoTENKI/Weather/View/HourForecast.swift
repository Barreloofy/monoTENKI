//
//  HourForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 4:33 PM.
//

import SwiftUI

struct HourForecast: View {
  @Environment(\.measurementSystem) private var measurementSystem

  @State private var hourID: Date?

  let hours: Hours

  var body: some View {
    VStack(spacing: 15) {
      ForEach(hours, id: \.time) { hour in
        Row(
          leading: { Text(hour.time.formatted(.shortenedAndTimeZoneNeutral)) },
          center: {
            Image(systemName: hour.condition.presentIcon(isDay: hour.isDay))
              .styled(size: 30)
          },
          trailing: { Text(hour.temperatureCelsius.temperatureFormatter(measurementSystem)) })
        .font(.title2)
        .contentShape(Rectangle())
        .onTapGesture { hourID = hour.time }
      }

      Spacer()
    }
    .detailPageHour(item: $hourID, hours: hours)
    .animation(.easeInOut.speed(0.5), value: hourID)
    .sensoryFeedback(.impact, trigger: hourID)
  }
}
