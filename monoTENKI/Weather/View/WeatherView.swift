//
//  WeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI
import AsyncAlgorithms

struct WeatherView: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(LocationAggregate.self) private var locationAggregate

  @State private var weatherAggregate = WeatherAggregate()
  @State private var showSettings = false
  @State private var showSearch = false
  @State private var showDetails = false

  // MARK: - Produces an 'AsyncTimerSequence' event every 30 minutes
  private let updateTimer = AsyncTimerSequence(interval: Duration.seconds(1800), clock: .continuous)

  var body: some View {
    Group {
      switch weatherAggregate.state {
      case .loading:
        colorScheme.background
      case .loaded(let currentWeather, let hourForecast, let dayForecast):
        VStack(spacing: 50) {

          ZStack {
            Button(
              action: { showSearch = true },
              label: { Text(currentWeather.location) })
            .sheet(isPresented: $showSearch) {
              SearchSheet()
                .presentationBackground(colorScheme.background)
            }
            AlignedHStack(alignment: .trailing) {
              Button(
                action: { showSettings = true },
                label: {
                  Image(systemName: "gear")
                    .styled(size: 25)
                })
              .sheet(isPresented: $showSettings) {
                Settings()
                  .presentationBackground(colorScheme.background)
              }
            }
          }

          TabView {
            ScrollView {
              LazyVStack(spacing: 0) {
                Today(weatherDetails: currentWeather)
                  .containerRelativeFrame(.vertical)
                  .onTapGesture { showDetails = true }
                HourForecast(hours: hourForecast)
                  .containerRelativeFrame(.vertical)
              }
              .fontWeight(.bold)
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.never)

            Text("Forecast")
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .todayDetailsPage(isPresented: $showDetails, weatherDetails: currentWeather)
        .tint(colorScheme.foreground)
        .padding()
      case .error:
        Text("Error")
      }
    }
    .task(id: locationAggregate.location) {
      await weatherAggregate.getWeather(for: locationAggregate.location)
    }
    .task {
      for await _ in updateTimer.debounce(for: .seconds(1)) {
        await weatherAggregate.getWeather(for: locationAggregate.location)
      }
    }
  }
}
