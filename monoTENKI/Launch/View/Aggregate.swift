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
  @Environment(LocationAggregate.self) private var locationAggregate

  @State private var weatherAggregate = WeatherAggregate()
  @AppStorage("apiSource") private var apiSourceInUse = APISource.weatherApi

  private let updateTimer = AsyncTimerSequence(interval: .seconds(900), clock: .continuous)

  var body: some View {
    VStack {
      switch weatherAggregate.state {
      case .loading:
        colorScheme.background

      case .loaded(let currentWeather, let hourForecast, let dayForecast):
        WeatherComposer(
          currentWeather: currentWeather,
          hourForecast: hourForecast,
          dayForecast: dayForecast,)

      case .error:
        RecoveryState(source: $apiSourceInUse) {
          await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
        }
      }
    }
    .tint(colorScheme.foreground)
    .task(id: locationAggregate.location) {
      await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
    }
    .task(id: apiSourceInUse) {
      for await _ in updateTimer.debounce(for: .seconds(1)) {
        await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
      }
    }
    .onChange(of: apiSourceInUse) {
      Task { await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse) }
    }
  }
}
