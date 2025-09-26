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
        .onTapGesture { hourID = hour.id }
        .accessibilityElement(children: .combine)

        Spacer()
      }
      .padding(.horizontal)
      .presence(active: hourID == nil)

      HourDetailPage(id: $hourID, hours: hours)
        .onTapGesture { hourID = nil }
        .presence(active: hourID != nil)
    }
    .containerRelativeFrame(.vertical)
    .animating(hourID, with: .easeIn(duration: 0.75))
    .sensoryFeedback(.impact, trigger: hourID)
  }
}
