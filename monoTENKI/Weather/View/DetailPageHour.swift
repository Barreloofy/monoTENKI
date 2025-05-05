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

  @Binding var present: Bool

  let hours: Hours
  let id: Date?

  func body(content: Content) -> some View {
    content
      .overlay {
        if present {
          ScrollView {
            LazyVStack(spacing: 0) {
              ForEach(hours) { hour in
                VStack(alignment: .leading, spacing: 10) {
                  Text(hour.time.formatted(.timeZoneNeutral))
                    .font(.system(size: 30))
                    .fontWeight(.bold)

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
          .onTapGesture { present = false }
          .onAppear { position = id }
        }
      }
  }
}


extension View {
  func detailPageHour(
    present: Binding<Bool>,
    hours: Hours,
    jumpTo: Date?) -> some View {
      modifier(
        DetailPageHour(
          present: present,
          hours: hours,
          id: jumpTo))
    }
}
