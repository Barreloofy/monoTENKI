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
  @AppStorage("measurementSystem") private var measurementUsed = MeasurementSystem.metric
  @State private var locationModel = LocationModel()

  @State private var showSheet = false

  var body: some Scene {
    WindowGroup {
      if setupCompleted {
        Settings()
      } else {
        Setup(setupCompleted: $setupCompleted)
          .foregroundStyle(.white)
      }
    }
    .environment(locationModel)
    .environment(\.measurementSystem, measurementUsed)
  }
}
