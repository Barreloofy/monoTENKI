//
// MeasurementSystem.swift
// monoTENKI
//
// Created by Barreloofy on 3/23/25 at 5:49 PM.
//

import SwiftUI

enum MeasurementSystem: String, Codable, Identifiable, CaseIterable {
  case metric
  case imperial

  var id: MeasurementSystem { self }
}


extension EnvironmentValues {
  @Entry var measurementSystemInUse = MeasurementSystem.metric
}


extension View {
  func measurementSystem(_ measurementSystem: MeasurementSystem) -> some View {
    environment(\.measurementSystemInUse, measurementSystem)
  }
}


extension Scene {
  func measurementSystem(_ measurementSystem: MeasurementSystem) -> some Scene {
    environment(\.measurementSystemInUse, measurementSystem)
  }
}
