//
// WeatherTimelineProvider.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:20 PM
//

import WidgetKit

struct WeatherTimelineProvider: TimelineProvider {
  typealias Entry = WeatherEntry

  func placeholder(in context: Context) -> Entry {
    WeatherEntry.mock
  }
  
  func getSnapshot(in context: Context, completion: @escaping @Sendable (Entry) -> Void) {
    if context.isPreview {
      completion(WeatherEntry.mock)
    } else {
      Task {
        let location = try await LocationManager.requestLocation().coordinate.stringRepresentation
        let weather = try await WeatherAggregate.weatherAPI.fetch(for: location)

        completion(WeatherEntry(date: .now, weather: weather))
      }
    }
  }
  
  func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<Entry>) -> Void) {
    Task {
      let location = try await LocationManager.requestLocation().coordinate.stringRepresentation
      let weather = try await WeatherAggregate.weatherAPI.fetch(for: location)

      let entry = WeatherEntry(date: .now, weather: weather)
      let nextDate = Calendar.current.date(byAdding: .minute, value: 15, to: .now)!

      let timeline = Timeline(entries: [entry], policy: .after(nextDate))
      completion(timeline)
    }
  }
}
