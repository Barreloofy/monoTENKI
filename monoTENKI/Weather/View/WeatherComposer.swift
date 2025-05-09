//
//  WeatherComposer.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI

struct WeatherComposer: View {
  @Environment(\.colorScheme) private var colorScheme

  @State private var presentSearch = false
  @State private var presentSettings = false

  let currentWeather: CurrentWeather
  let hourForecast: Hours
  let dayForecast: Days

  var body: some View {
    VStack(spacing: 25) {
      Row(
        leading: {},
        center: {
          Button(
            action: { presentSearch = true },
            label: { Text(currentWeather.location) })
          //.opacity(opacity)
          .sheet(isPresented: $presentSearch) {
            Search(setup: false)
              .presentationBackground(colorScheme.background)
          }
        },
        trailing: {
          Button(
            action: { presentSettings = true },
            label: {
              Image(systemName: "gear")
                .styled(size: 25)
            })
          .sheet(isPresented: $presentSettings) {
            Settings()
              .presentationBackground(colorScheme.background)
          }
        })
      .padding()

      ScrollView(.horizontal) {
        LazyHStack(spacing: 0) {
          ScrollView {
            LazyVStack(spacing: 0) {
              Today(current: currentWeather)
                .containerRelativeFrame(.vertical)

              HourForecast(hours: hourForecast)
                .containerRelativeFrame(.vertical)
            }
            .padding()
          }
          .scrollTargetBehavior(.paging)
          .scrollIndicators(.never)
          .containerRelativeFrame(.horizontal)

          DayForecast(days: dayForecast)
            .padding()
            .containerRelativeFrame(.horizontal)
        }
      }
      .ignoresSafeArea()
      .scrollTargetBehavior(.paging)
      .scrollIndicators(.never)
      .fontWeight(.bold)
      //.opacity(opacity)
    }
  }
}


/*
struct WeatherView: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(LocationAggregate.self) private var locationAggregate

  @State private var weatherAggregate = WeatherAggregate()
  @State private var state = WeatherAggregate.State.loading
  @State private var opacity = 1.0
  @State private var showSettings = false
  @State private var showSearch = false
  @AppStorage("apiSource") private var apiSourceInUse = APISource.weatherApi

  // MARK: - Produces an 'AsyncTimerSequence' event every 15 minutes
  private let updateTimer = AsyncTimerSequence(interval: .seconds(900), clock: .continuous)

  var body: some View {
    Group {
      switch state {
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
              .opacity(opacity)
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
                  Today(current: currentWeather)
                    .containerRelativeFrame(.vertical)

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
          .ignoresSafeArea()
          .fontWeight(.bold)
          .opacity(opacity)
        }
      case .error:
         VStack(spacing: 10) {
           Text("Error, check connection status, if the error persists please try again later")
             .font(.footnote)
           VStack(spacing: 5) {
             Text("Try diffrent Source")
               .font(.headline)
             HStack {
               Text(APISource.weatherApi.rawValue)
                 .selectedStyle(target: APISource.weatherApi, value: $apiSourceInUse)
               Text(APISource.accuWeather.rawValue)
                 .selectedStyle(target: APISource.accuWeather, value: $apiSourceInUse)
             }
             .font(.subheadline)
           }
         }
         .multilineTextAlignment(.center)
         .offset(y: -75)
      }
    }
    .padding()
    .tint(colorScheme.foreground)
    .task(id: locationAggregate.location) {
      await weatherAggregate.getWeather(for: locationAggregate.location, with: apiSourceInUse)
    }
    .task {
      for await _ in updateTimer.debounce(for: .seconds(1)) {
        await weatherAggregate.getWeather(for: locationAggregate.location, with: apiSourceInUse)
      }
    }
    .onChange(of: apiSourceInUse) {
      Task { await weatherAggregate.getWeather(for: locationAggregate.location, with: apiSourceInUse) }
    }
    .onAppear { state = weatherAggregate.state }
    .onChange(of: weatherAggregate.state) {
      Task {
        withAnimation(.easeIn(duration: 0.5)) { opacity = 0 }

        try await Task.sleep(for: .seconds(0.5))
        state = weatherAggregate.state

        withAnimation(.easeOut(duration: 0.5)) { opacity = 1 }
      }
    }
  }
}
*/
