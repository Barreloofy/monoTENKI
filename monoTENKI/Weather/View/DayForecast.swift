//
//  DayForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/25/25.
//

import SwiftUI

struct DayForecast: View {
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
          .subtitleFont()
          .contentShape(Rectangle())
          .onTapGesture { dayID = day.date }
          .accessibilityElement(children: .combine)
        }
      }
      .padding(.horizontal)
      .presence(active: dayID == nil)

      DayDetailPage(id: $dayID, days: days)
        .presence(active: dayID != nil)
        .onTapGesture { dayID = nil }
    }
    .containerRelativeFrame([.vertical, .horizontal], alignment: .top)
    .animating(dayID, with: .easeIn(duration: 0.75))
    .sensoryFeedback(.impact, trigger: dayID)
  }
}
