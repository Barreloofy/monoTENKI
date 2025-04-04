//
//  WeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI
import os
import AsyncAlgorithms

struct WeatherView: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(LocationModel.self) private var locationModel

  @State private var weatherModel = WeatherModel()
  @State private var showSettings = false
  @State private var showSearch = false
  @State private var showDetails = false

  private let updateTimer = AsyncTimerSequence(interval: Duration.seconds(1800), clock: .continuous)

  var body: some View {
    VStack {

      ZStack {
        Button(
          action: { showSearch = true },
          label: {
            Text(verbatim: weatherModel.currentWeather.location)
          })
        .sheet(isPresented: $showSearch) {
          SearchWeather()
            .presentationBackground(colorScheme == .light ? .white : .black)
        }

        AlignedHStack(alignment: .trailing) {
          Button(
            action: { showSettings = true },
            label: {
              Image(systemName: "gear")
                .resizable()
                .scaledToFit()
                .fontWeight(.regular)
                .frame(width: 25)
            })
          .sheet(isPresented: $showSettings) {
            Settings()
              .presentationBackground(colorScheme == .light ? .white : .black)
          }
        }
      }
      .padding(.top, 25)
      .padding(.bottom, 50)

      TabView {
        ScrollView {
          LazyVStack(spacing: 0) {
            Today(weatherDetails: weatherModel.currentWeather)
              .containerRelativeFrame(.vertical)
              .onTapGesture { showDetails = true }

            HourForecast(hours: weatherModel.hourForecast)
              .containerRelativeFrame(.vertical)
          }
          .fontWeight(.bold)
        }
        .ignoresSafeArea()
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.never)

        Text("Forecast")
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
    }
    .tint(colorScheme.tint())
    .padding(.horizontal)
    .detailsPage(isPresented: $showDetails, weatherDetails: weatherModel.currentWeather)
    .task(id: locationModel.location) {
      do {
        try await weatherModel.getWeather(for: locationModel.location)
      } catch {
        Logger().error("\(error.localizedDescription) In: task(id: locationModel.location)")
      }
    }
    .task {
      for await _ in updateTimer.debounce(for: .seconds(1)) {
        print("Update")
        do {
          try await weatherModel.getWeather(for: locationModel.location)
        } catch {
          Logger().error("\(error.localizedDescription) In: task(id: locationModel.location)")
        }
      }
    }
  }
}
