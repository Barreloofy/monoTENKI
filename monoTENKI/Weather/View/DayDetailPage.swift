//
//  DayDetailPage.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/15/25 at 12:38 PM.
//

import SwiftUI

struct DayDetailPage: View {
  @Binding var id: Date?

  let days: Days

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(days) { day in
          VStack(alignment: .leading, spacing: 10) {
            Text(day.date.formatted(.dateTime.weekday(.wide)))
              .subheadlineFont()

            DetailSection(title: "Temperatures") {
              TemperatureView(
                "AVG",
                day.temperatures.celsiusAverage,
                accessibilityText: "Average")

              TemperatureView("High", day.temperatures.celsiusHigh)

              TemperatureView("Low", day.temperatures.celsiusLow)
            }

            DetailSection(title: "Precipitation") {
              Text("Chance \(day.precipitation.chance.formatted(.percent))")

              PrecipitationView("Total", day.precipitation.totalMillimeter)

              Text("Type \(day.precipitation.type)")
            }
          }
          .containerRelativeFrame(.vertical)
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.paging)
    .scrollPosition(id: $id)
    .scrollIndicators(.never)
    .applyOnInteractiveResizeChangeIfAvailable { isResizing in
      if isResizing { id = nil }
    }
  }
}
