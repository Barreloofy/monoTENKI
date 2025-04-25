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
  @AppStorage("measurementSystemInUse") private var measurementSystemInUse = MeasurementSystem.metric
  @State private var locationAggregate = LocationAggregate()

  var body: some Scene {
    WindowGroup {
      if setupCompleted {
        WeatherView()
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
    .environment(\.measurementSystem, measurementSystemInUse)
  }
}
