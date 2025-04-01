//
//  monoTENKIApp.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import SwiftUI

@main
struct monoTENKIApp: App {
  @Environment(\.colorScheme) private var colorScheme

  @AppStorage("setupCompleted") private var setupCompleted = false
  @AppStorage("measurementSystem") private var measurementUsed = MeasurementSystem.metric
  @State private var locationModel = LocationModel()

  var body: some Scene {
    WindowGroup {
      if setupCompleted {
        WeatherView()
          .tint(colorScheme.tint())
          .textCase(.uppercase)
      } else {
        Setup(setupCompleted: $setupCompleted)
          .tint(colorScheme.tint())
          .textCase(.uppercase)
      }
    }
    .environment(locationModel)
    .environment(\.measurementSystem, measurementUsed)
  }
}
