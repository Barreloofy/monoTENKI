//
// WeatherWidget.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:37 PM
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: "WeatherWidget",
      provider: WeatherTimelineProvider()) { entry in
        WeatherView(entry: entry)
          .containerBackground(.background, for: .widget)
          .dynamicTypeSize(...DynamicTypeSize.large)
      }
      .configurationDisplayName("Current Weather overview")
      .description("Sleek, minimalist widget providing a quick overview of current weather conditions.")
      .supportedFamilies([.systemSmall])
  }
}
