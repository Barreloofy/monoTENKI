//
// Aggregate.swift
// monoTENKI
//
// Created by Barreloofy on 11/7/25 at 12:55 PM
//

import SwiftUI

struct Aggregate: View {
  let entry: WeatherEntry

  var body: some View {
    Group {
      if let weather = entry.weather {
        WeatherView(weather: weather)
      } else {
        UnavailableView()
      }
    }
    .lineLimit(1)
    .minimumScaleFactor(0.5)
    .dynamicTypeSize(...DynamicTypeSize.large)
    .containerBackground(.background, for: .widget)
  }
}
