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
            center: { WeatherListSymbol(name: day.condition, isDay: true) },
            trailing: { TemperatureView(day.temperatures.celsiusAverage) })
          .overviewFont()
          .contentShape(Rectangle())
          .onTapGesture { dayID = day.date }
          .accessibilityElement(children: .combine)
        }
      }
      .padding(.horizontal)
      .enabled(dayID == nil)

      DayDetailPage(id: $dayID, days: days)
        .enabled(dayID != nil)
    }
    .containerRelativeFrame([.vertical, .horizontal], alignment: .top)
    .animation(reduceMotion ? nil : .easeInOut(duration: 0.75), value: dayID)
    .sensoryFeedback(.impact, trigger: dayID)
  }
}
