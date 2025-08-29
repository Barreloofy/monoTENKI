//
//  HourForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/2/25 at 4:33 PM.
//

import SwiftUI

struct HourForecast: View {
  @State private var hourID: Date?

  let hours: Hours

  var body: some View {
    VStack {
      ForEach(hours) { hour in
        Row(
          leading: { Text(hour.time.formatted(.shortenedAndTimeZoneNeutral)) },
          center: { WeatherListSymbol(name: hour.condition, isDay: hour.isDay) },
          trailing: { TemperatureView(hour.temperatureCelsius) })
        .subtitleFont()
        .contentShape(Rectangle())
        .onTapGesture { hourID = hour.time }
        .accessibilityElement(children: .combine)

        Spacer()
      }
      .padding(.horizontal)
      .enabled(hourID == nil)

      HourDetailPage(id: $hourID, hours: hours)
        .enabled(hourID != nil)
    }
    .containerRelativeFrame(.vertical, alignment: .top)
    .animating(hourID, with: .easeInOut(duration: 1))
    .sensoryFeedback(.impact, trigger: hourID)
  }
}
