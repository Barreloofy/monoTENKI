//
//  DetailPageDay.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/15/25 at 12:38 PM.
//

import SwiftUI

struct DetailPageDay: ViewModifier {
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
                      day.temperatureCelsiusAverage,
                      accessibilityText: "Average")

                    TemperatureView("High", day.temperatureCelsiusHigh)

                    TemperatureView("Low", day.temperatureCelsiusLow)
                  }

                  DetailSection(title: "Precipitation") {
                    Text("Chance \(day.precipitationChance.formatted(.percent))")

                    PrecipitationView("Total", day.precipitationTotalMillimeter)

                    Text("Type \(day.precipitationType)")
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
        DetailPageDay(
          id: item,
          days: days))
  }
}
