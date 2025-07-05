//
//  Aggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI
import AsyncAlgorithms

struct Aggregate: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.apiSource) private var apiSource
  @Environment(LocationAggregate.self) private var locationAggregate

  @State private var weatherAggregate = WeatherAggregate()
  @State private var refreshDate = Date.nextRefreshDate
  @State private var apiSourceInUse = APISource.weatherAPI

  var body: some View {
    VStack {
      switch weatherAggregate.state {
      case .loading:
        Loading()

      case .loaded(let currentWeather, let hourForecast, let dayForecast):
        WeatherComposer(
          currentWeather: currentWeather,
          hourForecast: hourForecast,
          dayForecast: dayForecast)

      case .error:
        Recovery() {
          weatherAggregate.state = .loading
          await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
        }
      }
    }
    .tint(colorScheme.foreground)
    .onChange(of: apiSource, initial: true) { apiSourceInUse = apiSource }
    .task(id: locationAggregate.location) {
      await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
      refreshDate = .nextRefreshDate
    }
    .task {
      for await _ in AsyncTimerSequence(interval: .seconds(900), clock: .continuous) where Date() > refreshDate {
        await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
        refreshDate = .nextRefreshDate
      }
    }
    .asyncOnChange(id: apiSource) {
      guard weatherAggregate.state != .error else { return }

      await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
      refreshDate = .nextRefreshDate
    }
  }
}
