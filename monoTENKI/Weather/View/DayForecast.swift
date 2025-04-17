//
//  DayForecast.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/12/25 at 2:08 PM.
//

import SwiftUI

struct DayForecast: View {
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(\.colorScheme) private var colorScheme

  @State private var showDetails = false

  let day: Day

  var body: some View {
    VStack {
      Text(day.date.formatted(.dateTime.weekday(.wide)))
        .font(.system(size: 30))
        .fontWeight(.bold)

      HStack(spacing: 25) {
        Image(systemName: day.condition.presentIcon(isDay: 1))
          .styled(size: 125)

        Text(day.temperatureCelsiusAverage.temperatureFormatter(measurementSystem))
          .font(.system(size: 30))
          .fontWeight(.bold)
      }
      .offset(x: 10)
    }
    .frame(width: 250, height: 225)
    .contentShape(Rectangle())
    .onTapGesture {
      withAnimation(.easeInOut.speed(0.5)) { showDetails = true }
    }
    .detailPageDay(present: $showDetails, day: day)
  }
}
