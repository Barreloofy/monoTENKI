//
//  DetailPageHour.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/28/25.
//

import SwiftUI

struct DetailPageHour: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem

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
                    Text("Chance \(hour.precipitationChance.formatted(.percent))")

                    Text("Rate \(hour.precipitationRateMillimeter.precipitationFormatter(measurementSystem))")

                    Text("Type \(hour.precipitationType)")
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
        DetailPageHour(
          id: item,
          hours: hours))
    }
}
