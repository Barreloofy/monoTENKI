//
//  HourDetailPage.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/28/25.
//

import SwiftUI

struct HourDetailPage: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  @State private var position: Date?

  @Binding var id: Date?

  let hours: Hours

  func body(content: Content) -> some View {
    content
      .overlay {
        if let id = id {
          ScrollView {
            LazyVStack(spacing: 0) {
              ForEach(hours) { hour in
                VStack(alignment: .leading, spacing: 10) {
                  Text(hour.time.formatted(.shortenedAndTimeZoneNeutral))
                    .font(.system(size: 30))

                  DetailSection(title: "Precipitation") {
                    Text("Chance \(hour.precipitation.chance.formatted(.percent))")

                    PrecipitationView("Rate", hour.precipitation.rateMillimeter)

                    Text("Type \(hour.precipitation.type)")
                  }

                  DetailSection(title: "Wind") {
                    Text("Direction \(hour.wind.direction)")
                      .accessibilityLabel(hour.wind.direction.windDirectionWide())

                    SpeedView("Speed", hour.wind.speedKilometersPerHour)

                    SpeedView("Gust", hour.wind.gustKilometersPerHour)
                  }
                }
                .containerRelativeFrame(.vertical)
                .offset(y: -50)
              }
            }
            .scrollTargetLayout()
          }
          .scrollTargetBehavior(.paging)
          .scrollIndicators(.never)
          .scrollPosition(id: $position)
          .background(colorScheme.background)
          .onTapGesture { self.id = nil }
          .onAppear { position = id }
        }
      }
  }
}


extension View {
  func detailPageHour(
    item: Binding<Date?>,
    hours: Hours) -> some View {
      modifier(
        HourDetailPage(
          id: item,
          hours: hours))
    }
}
