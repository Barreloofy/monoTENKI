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

  @AppStorage(.key(.setupCompleted)) private var setupCompleted = false
  @AppStorage(.key(.userModifiedMeasurementSystem)) private var userModifiedMeasurementSystem = false
  @AppStorage(.key(.measurementSystemInUse)) private var measurementSystemInUse = MeasurementSystem.metric
  @AppStorage(.key(.apiSourceInUse)) private var apiSourceInUse = APISource.weatherAPI
  @AppStorage(.key(.nightVision)) private var nightVision = false
  @State private var locationAggregate = LocationAggregate()

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
      default: break
      }
    }
    .environment(locationAggregate)
    .apiSource(apiSourceInUse)
    .measurementSystem(measurementSystemInUse)
    .nightVision(nightVision)
  }
}
