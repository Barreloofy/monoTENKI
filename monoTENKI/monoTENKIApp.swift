//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
  @Environment(\.scenePhase) private var scenePhase

  @AppStorage("setupCompleted") private var setupCompleted = false
  @AppStorage("measurementSystem") private var measurementSystemInUse = MeasurementSystem.metric
  @AppStorage("apiSource") private var apiSourceInUse = APISource.weatherAPI
  @State private var locationAggregate = LocationAggregate()

  var body: some Scene {
    WindowGroup {
      if setupCompleted {
        Aggregate()
          .configureFont()
      } else {
        Setup(setupCompleted: $setupCompleted)
          .configureFont()
      }
    }
    .onChange(of: scenePhase) {
      print(scenePhase)
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
