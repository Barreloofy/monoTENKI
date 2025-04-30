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
  @State private var source = Source.value

  // MARK: - Produces an 'AsyncTimerSequence' event every 15 minutes
  private let updateTimer = AsyncTimerSequence(interval: .seconds(900), clock: .continuous)

  var body: some View {
    Group {
      switch weatherAggregate.state {
      case .loading:
        colorScheme.background
      case .loaded(let currentWeather, let hourForecast, let dayForecast):
        VStack(spacing: 50) {
          Row(
            leading: {},
            center: {
              Button(
                action: { showSearch = true },
                label: { Text(currentWeather.location) })
              .sheet(isPresented: $showSearch) {
                Search(setup: false)
                  .presentationBackground(colorScheme.background)
              }
            },
            trailing: {
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
            })

          ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
              ScrollView {
                LazyVStack(spacing: 0) {
                  Today(weather: currentWeather)
                    .containerRelativeFrame([.vertical, .horizontal])
                    .contentShape(Rectangle())
                    .onTapGesture {
                      withAnimation(.easeInOut.speed(0.5)) { showDetails = true }
                    }
                    .detailPageCurrent(present: $showDetails, current: currentWeather)

                  HourForecast(hours: hourForecast)
                    .containerRelativeFrame(.vertical)
                }
              }
              .scrollTargetBehavior(.paging)
              .scrollIndicators(.never)
              .containerRelativeFrame(.horizontal)

              DayForecast(days: dayForecast)
                .containerRelativeFrame(.horizontal)
            }
          }
          .scrollTargetBehavior(.paging)
          .scrollIndicators(.never)
          .fontWeight(.bold)
        }
        .padding()
      case .error:
        VStack(spacing: 10) {
          Text("Error, check connection status, if the error persists please try again later")
            .font(.footnote)
          VStack(spacing: 5) {
            Text("Try diffrent Source:")
              .font(.headline)
            HStack {
              Text(APISource.WeatherAPI.rawValue)
                .selectedStyle(target: APISource.WeatherAPI, value: $source)
              Text(APISource.AccuWeather.rawValue)
                .selectedStyle(target: APISource.AccuWeather, value: $source)
            }
            .font(.subheadline)
          }
        }
        .multilineTextAlignment(.center)
        .offset(y: -75)
        .padding()
      }
    }
    .tint(colorScheme.foreground)
    .onChange(of: source) {
      Source.value = source
      Task {
        await weatherAggregate.getWeather(for: locationAggregate.location)
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
