//
//  DayDetailPage.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/15/25 at 12:38 PM.
//

import SwiftUI

struct DayDetailPage: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  @State private var position: Date?

  @Binding var id: Date?

  let days: Days

  func body(content: Content) -> some View {
    content
      .overlay {
        if let id = id {
          ScrollView {
            LazyVStack(spacing: 0) {
              ForEach(days, id: \.date) { day in
                VStack(alignment: .leading, spacing: 10) {
                  Text(day.date.formatted(.dateTime.weekday(.wide)))
                    .font(.system(size: 30))

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
  func detailPageDay(
    item: Binding<Date?>,
    days: Days) -> some View {
      modifier(
        DayDetailPage(
          id: item,
          days: days))
  }
}
