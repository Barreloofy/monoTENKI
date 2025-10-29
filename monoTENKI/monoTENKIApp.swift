//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
  @Environment(\.locale) private var locale
  @Environment(\.scenePhase) private var scenePhase

  @AppStorage(\.setupCompleted) private var setupCompleted
  @AppStorage(\.userModifiedMeasurementSystem) private var userModifiedMeasurementSystem
  @AppStorage(\.measurementSystemInUse) private var measurementSystemInUse
  @AppStorage(\.apiSourceInUse) private var apiSourceInUse
  @AppStorage(\.nightVision) private var nightVision

  @State private var locationAggregate = LocationAggregate()
  @State private var weatherAggregate = WeatherAggregate()

  var body: some Scene {
    WindowGroup {
      Group {
        if setupCompleted {
          Aggregate()
        } else {
          Setup(setupCompleted: $setupCompleted)
        }
      }
      .configureApp()
    }
    .onChange(of: locale.measurementSystem, initial: true) {
      guard !userModifiedMeasurementSystem else { return }
      switch locale.measurementSystem {
      case .metric: measurementSystemInUse = .metric
      default: measurementSystemInUse = .imperial
      }
    }
    .onChange(of: scenePhase) {
      switch scenePhase {
      case .active: locationAggregate.resume()
      case .background: locationAggregate.suspend()
      default: return
      }
    }
    .environment(locationAggregate)
    .environment(weatherAggregate)
    .apiSource(apiSourceInUse)
    .measurementSystem(measurementSystemInUse)
    .nightVision(nightVision)
    .modifiedMeasurementSystem(userModifiedMeasurementSystem)
  }
}
