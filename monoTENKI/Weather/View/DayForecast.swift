//
//  DayForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/25/25.
//

import SwiftUI

struct DayForecast: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  @State private var dayID: Date?

  let days: Days

  var body: some View {
    VStack {
      VStack(spacing: 30) {
        ForEach(days) { day in
          Row(
            leading: { Text(day.date.formatted(.dateTime.weekday(.wide))) },
            center: {
              WeatherIcon(
                name: day.condition,
                isDay: true,
                usage: .overview)
            },
            trailing: { TemperatureView(day.temperatures.celsiusAverage) })
          .overviewFont()
          .contentShape(Rectangle())
          .onTapGesture { dayID = day.date }
        }
      }
      .enabled(dayID == nil)

      DayDetailPage(id: $dayID, days: days)
    }
    .animation(reduceMotion ? nil : .easeInOut(duration: 0.75), value: dayID)
    .sensoryFeedback(.impact, trigger: dayID)
  }
}
