//
//  Aggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/8/25.
//

import SwiftUI
import AsyncAlgorithms
import CoreLocation

struct Aggregate: View {
  @Environment(LocationAggregate.self) private var locationAggregate

  @State private var weatherAggregate = WeatherAggregate()
  @State private var refreshDate = Date.nextRefreshDate

  var body: some View {
    Group {
      switch weatherAggregate.state {
      case .loading:
        Loading()

      case .loaded(let currentWeather, let hourForecast, let dayForecast):
        WeatherComposite(
          currentWeather: currentWeather,
          hourForecast: hourForecast,
          dayForecast: dayForecast)

      case .error:
        Recovery() {}
      }
    }
    .task(id: locationAggregate.location) {
      await weatherAggregate.getWeather(for: locationAggregate.location, from: .weatherAPI)
    }
  }
}
































/*
 @Environment(\.apiSource) private var apiSource

 @State private var apiSourceInUse = APISource.weatherAPI

 private let refreshTimer = AsyncTimerSequence(interval: .seconds(900), clock: .continuous)

 {
   weatherAggregate.state = .loading
   await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
   refreshDate = .nextRefreshDate
 }

 .onChange(of: apiSource, initial: true) { apiSourceInUse = apiSource }
 .task(id: locationAggregate.location) {
   await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
   refreshDate = .nextRefreshDate
 }
 .task {
   for await _ in updateTimer where Date() > refreshDate {
     await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
     refreshDate = .nextRefreshDate
   }
 }
 .asyncOnChange(id: apiSource) {
   guard weatherAggregate.state != .error else { return }
   await weatherAggregate.getWeather(for: locationAggregate.location, from: apiSourceInUse)
   refreshDate = .nextRefreshDate
 }
 */
