//
//  DayForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/25/25.
//

import SwiftUI

struct DayForecast: View {
  @Environment(\.measurementSystem) private var measurementSystem

  @State private var presentDetails = false
  @State private var dayID: Date?

  let days: Days

  var body: some View {
    VStack(spacing: 15) {
      ForEach(days) { day in
        Row(
          leading: { Text(day.date.formatted(.dateTime.weekday(.wide))) },
          center: {
            Image(systemName: day.condition.presentIcon(isDay: true))
              .styled(size: 30)
          },
          trailing: { Text(day.temperatureCelsiusAverage.temperatureFormatter(measurementSystem)) })
        .font(.title2)
        .contentShape(Rectangle())
        .onTapGesture {
          dayID = day.date
          presentDetails = true
        }
      }

      Spacer()
    }
    .detailPageDay(present: $presentDetails, days: days, jumpTo: dayID)
    .animation(.easeInOut.speed(0.5), value: presentDetails)
  }
}
