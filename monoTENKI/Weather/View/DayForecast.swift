//
//  DayForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/25/25.
//

import SwiftUI

struct DayForecast: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  @State private var dayID: Date?

  let days: Days

  var body: some View {
    VStack(spacing: 15) {
      ForEach(days) { day in
        Row(
          leading: { Text(day.date.formatted(.dateTime.weekday(.wide))) },
          center: {
            WeatherIcon(
              name: day.condition,
              isDay: true,
              size: horizontalSizeClass == .compact ? 30 : 45)
          },
          trailing: { TemperatureView(day.temperatures.celsiusAverage) })
        .font(horizontalSizeClass == .compact ? .title2 : .title)
        .contentShape(Rectangle())
        .onTapGesture { dayID = day.date }
      }

      Spacer()
    }
    .accessibilityHidden((dayID != nil))
    .detailPageDay(item: $dayID, days: days)
    .animation(reduceMotion ? nil : .easeInOut.speed(0.5), value: dayID)
    .sensoryFeedback(.impact, trigger: dayID)
  }
}
