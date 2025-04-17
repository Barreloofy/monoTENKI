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

  @Binding var present: Bool

  let day: Day

  func body(content: Content) -> some View {
    content
      .overlay {
        if present {
          ZStack {
            colorScheme.background
            VStack(alignment: .leading, spacing: 10) {
              DetailSection(title: "Temperatures") {
                Text("AVG \(day.temperatureCelsiusAverage.temperatureFormatter(measurementSystem))")

                Text("High \(day.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))")

                Text("Low \(day.temperatureCelsiusLow.temperatureFormatter(measurementSystem))")
              }

              DetailSection(title: "Precipitation") {
                Text("Chance \(day.precipitationChance.formatted(.percent))")

                Text("Total \(day.precipitationMillimeterTotal.precipitationFormatter(measurementSystem))")

                Text("Type \(day.type)")
              }
            }
          }
          .onTapGesture {
            withAnimation(.easeInOut.speed(0.5)) { present = false }
          }
        }
      }
  }
}


extension View {
  func detailPageDay(present: Binding<Bool>, day: Day) -> some View {
    modifier(
      DetailPageDay(
        present: present,
        day: day
      )
    )
  }
}
