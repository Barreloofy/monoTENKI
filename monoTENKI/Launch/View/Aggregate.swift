//
//  Aggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI
import AsyncAlgorithms

struct Aggregate: View {
  @Environment(LocationAggregate.self) private var locationAggregate
  @Environment(\.apiSource) private var apiSource

  @State private var weatherAggregate = WeatherAggregate()
  @State private var apiSourceInUse = APISource.weatherAPI
  @State private var refreshDate = Date.nextRefreshDate

  let updateTimer = AsyncTimerSequence(
    interval: .seconds(900),
    clock: .continuous)

  var body: some View {
    Group {
      switch weatherAggregate() {
      case .loading:
        Loading()

      case .loaded(
        let currentWeather,
        let hourForecast,
        let dayForecast):
          WeatherComposite(
            currentWeather: currentWeather,
            hourForecast: hourForecast,
            dayForecast: dayForecast)

      case .error:
        Recovery() {
          await weatherAggregate.getWeather(
            for: locationAggregate.location,
            from: apiSourceInUse,
            resetState: true)
          refreshDate = .nextRefreshDate
        }
      }
    }
    .onChange(of: apiSource, initial: true) {
      apiSourceInUse = apiSource
    }
    .task(id: apiSourceInUse) {
      guard weatherAggregate() != .error else { return }
      await weatherAggregate.getWeather(
        for: locationAggregate.location,
        from: apiSourceInUse)
      refreshDate = .nextRefreshDate
    }
    .task(id: locationAggregate.location) {
      await weatherAggregate.getWeather(
        for: locationAggregate.location,
        from: apiSourceInUse)
      refreshDate = .nextRefreshDate
    }
    .task {
      for await _ in updateTimer where Date() > refreshDate {
        await weatherAggregate.getWeather(
          for: locationAggregate.location,
          from: apiSourceInUse)
        refreshDate = .nextRefreshDate
      }
    }
  }
}
