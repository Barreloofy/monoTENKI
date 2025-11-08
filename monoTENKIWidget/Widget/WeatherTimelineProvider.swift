//
// WeatherTimelineProvider.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:20 PM
//

import WidgetKit
import CoreLocation

struct WeatherTimelineProvider: TimelineProvider {
  typealias Entry = WeatherEntry

  func placeholder(in context: Context) -> Entry {
    .placeholder
  }

  func getSnapshot(in context: Context, completion: @escaping @Sendable (Entry) -> Void) {
    completion(.preview)
  }

  func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<Entry>) -> Void) {
    Task {
      do {
        let location = try await CLLocationUpdate.currentLocation()

        let weather = try await WeatherAPI.fetchWeather(for: location.coordinate).create()

        completion(Timeline(entries: [WeatherEntry(weather: weather)], policy: .atEnd))
      } catch {
        completion(Timeline(entries: [.placeholder], policy: .atEnd))
      }
    }
  }
}
