//
//  HourDetailPage.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/28/25.
//

import SwiftUI

struct HourDetailPage: View {
  @Binding var id: Date?

  let hours: Hours

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(hours) { hour in
          VStack(alignment: .leading, spacing: 10) {
            Text(hour.time.formatted(.shortenedAndTimeZoneNeutral))
              .subheadlineFont()

            DetailSection(title: "Precipitation") {
              Text("Chance \(hour.precipitation.chance.formatted(.percent))")

              PrecipitationView("Rate", hour.precipitation.rateMillimeter)

              Text("Type \(hour.precipitation.type)")
            }

            DetailSection(title: "Wind") {
              Text("Direction \(hour.wind.direction)")
                .accessibilityLabel(hour.wind.direction.formatted(.windDirectionWide))

              SpeedView("Speed", hour.wind.speedKilometersPerHour)

              SpeedView("Gust", hour.wind.gustKilometersPerHour)
            }
          }
          .offset(y: -100)
          .safeAreaPadding(.top, 100)
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
