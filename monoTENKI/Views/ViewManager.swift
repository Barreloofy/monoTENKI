//
//  ViewManager.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 9:34 PM.
//

import SwiftUI

enum ViewState {
  case loading
  case loaded
  case error
}


struct ViewManager: View {
  @Environment(\.scenePhase) private var scenePhase
  @EnvironmentObject private var weatherData: WeatherData
  @EnvironmentObject private var unitData: UnitData
  @ObservedObject private var locationManager = LocationManager.shared
  @State private var state = ViewState.loading

  var body: some View {
    Group {
      switch state {
      case .loading:
        loadingView
      case .loaded:
        WeatherView()
      case .error:
        FetchError(state: $state)
      }
    }
    .onChange(of: scenePhase) {
      guard scenePhase == .active else { return }
      Task {
        do {
          try await weatherData.fetchWeather()
        } catch {
          state = .error
        }
      }
    }
    .onChange(of: weatherData.currentLocation, initial: true) {
      Task {
        do {
          try await weatherData.fetchWeather()
          state = .loaded
        } catch {
          state = .error
        }
      }
    }
    .onChange(of: locationManager.currentLocation) {
      guard locationManager.trackLocation else { return }
      Task {
        do {
          try await weatherData.setWeatherToCurrentLocation()
        } catch {
          state = .error
        }
      }
    }
  }

  private var loadingView: some View {
    Color(.black).ignoresSafeArea()
  }
}
