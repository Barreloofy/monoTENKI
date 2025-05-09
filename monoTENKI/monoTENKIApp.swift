//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
  @AppStorage("setupCompleted") private var setupCompleted = false
  @AppStorage("measurementSystem") private var measurementSystemInUse = MeasurementSystem.metric
  @AppStorage("apiSource") private var apiSourceInUse = APISource.weatherApi
  @State private var locationAggregate = LocationAggregate()

  var body: some Scene {
    WindowGroup {
      if setupCompleted {
        Aggregate()
          .textCase(.uppercase)
          .fontDesign(.monospaced)
          .fontWeight(.medium)
      } else {
        Setup(setupCompleted: $setupCompleted)
          .textCase(.uppercase)
          .fontDesign(.monospaced)
          .fontWeight(.medium)
      }
    }
    .environment(locationAggregate)
    .environment(\.apiSource, apiSourceInUse)
    .environment(\.measurementSystem, measurementSystemInUse)
  }
}
