//
//  DayForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/25/25.
//

import SwiftUI

struct DayForecast: View {
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(\.colorScheme) private var colorScheme

  @State private var presentDetails = false
  @State private var dayID: Date?

  let days: Days

  var body: some View {
    VStack {
      ForEach(days, id: \.date) { day in
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
          withAnimation(.easeInOut.speed(0.5)) {
            dayID = day.date
            presentDetails = true
          }
        }
      }

      Spacer()
    }
    .detailPageDay(present: $presentDetails, days: days, jumpTo: dayID)
  }
}
