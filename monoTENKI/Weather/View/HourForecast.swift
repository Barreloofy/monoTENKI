//
//  HourForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 4:33 PM.
//

import SwiftUI

struct HourForecast: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  @State private var hourID: Date?

  let hours: Hours

  var body: some View {
    VStack {
      VStack(spacing: 0) {
        ForEach(hours) { hour in
          Row(
            leading: { Text(hour.time.formatted(.shortenedAndTimeZoneNeutral)) },
            center: {
              WeatherIcon(
                name: hour.condition,
                isDay: hour.isDay,
                usage: .overview)
            },
            trailing: { TemperatureView(hour.temperatureCelsius) })
          .overviewFont()
          .contentShape(Rectangle())
          .onTapGesture { hourID = hour.time }

          Spacer()
        }
      }
      .enabled(hourID == nil)

      HourDetailPage(id: $hourID, hours: hours)
    }
    .animation(reduceMotion ? nil : .easeInOut(duration: 0.75), value: hourID)
    .sensoryFeedback(.impact, trigger: hourID)
  }
}
