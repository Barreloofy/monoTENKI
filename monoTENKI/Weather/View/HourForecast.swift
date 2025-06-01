//
//  HourForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 4:33 PM.
//

import SwiftUI

struct HourForecast: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  @State private var hourID: Date?

  let hours: Hours

  var body: some View {
    VStack(spacing: 15) {
      ForEach(hours, id: \.time) { hour in
        Row(
          leading: { Text(hour.time.formatted(.shortenedAndTimeZoneNeutral)) },
          center: { WeatherIcon(name: hour.condition, isDay: hour.isDay, size: 30) },
          trailing: { TemperatureView(hour.temperatureCelsius) })
        .font(.title2)
        .contentShape(Rectangle())
        .onTapGesture { hourID = hour.time }
      }

      Spacer()
    }
    .accessibilityHidden((hourID != nil))
    .detailPageHour(item: $hourID, hours: hours)
    .animation(reduceMotion ? nil : .easeInOut.speed(0.5), value: hourID)
    .sensoryFeedback(.impact, trigger: hourID)
  }
}
