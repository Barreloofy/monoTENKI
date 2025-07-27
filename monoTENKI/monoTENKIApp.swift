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

  @AppStorage(StorageKeys.setupCompleted.rawValue) private var setupCompleted = false
  @AppStorage(StorageKeys.userModifiedMeasurementSystem.rawValue) private var userModifiedMeasurementSystem = false
  @AppStorage(StorageKeys.measurementSystemInUse.rawValue) private var measurementSystemInUse = MeasurementSystem.metric
  @AppStorage(StorageKeys.apiSourceInUse.rawValue) private var apiSourceInUse = APISource.weatherAPI
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
      .contentConfigure()
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
    .environment(\.apiSource, apiSourceInUse)
    .environment(\.measurementSystem, measurementSystemInUse)
  }
}
