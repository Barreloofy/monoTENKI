//
//  DetailPageDay.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/15/25 at 12:38 PM.
//

import SwiftUI

struct DetailPageDay: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem

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
                    Text("AVG \(day.temperatureCelsiusAverage.temperatureFormatter(measurementSystem))")

                    Text("High \(day.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))")

                    Text("Low \(day.temperatureCelsiusLow.temperatureFormatter(measurementSystem))")
                  }

                  DetailSection(title: "Precipitation") {
                    Text("Chance \(day.precipitationChance.formatted(.percent))")

                    Text("Total \(day.precipitationTotalMillimeter.precipitationFormatter(measurementSystem))")

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
