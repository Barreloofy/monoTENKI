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
      VStack(alignment: .leading, spacing: 30) {
        ForEach(days) { day in
          HStack {
            VStack(alignment: .leading) {
              Text(day.date.formatted(.dateTime.weekday(.wide)))
                .subtitleFont()
                .frame(width: 150, alignment: .leading)
              WeatherListSymbol(name: day.condition, isDay: true)
            }

            VStack(alignment: .leading) {
              TemperatureView("AVG",day.temperatures.celsiusAverage)

              TemperatureView("HIGH", day.temperatures.celsiusHigh)

              TemperatureView("LOW", day.temperatures.celsiusLow)
            }
            .footnoteFont()
          }
          .contentShape(Rectangle())
          .onTapGesture { dayID = day.id }
          .accessibilityElement(children: .combine)
        }
      }
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


#Preview {
  let days = (0...6).map { advance in
    Day(
      date: .init(timeIntervalSinceNow: 86400 * Double(advance)),
      condition: "Sunny",
      temperatures: .init(celsiusAverage: 15, celsiusLow: 9, celsiusHigh: 20),
      precipitation: .init(chance: 56, totalMillimeter: 3, type: "Rain"))
  }

  DayForecast(days: days)
}
