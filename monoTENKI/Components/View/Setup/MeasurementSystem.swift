//
//  MeasurementSystem.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/23/25 at 5:49 PM.
//

import SwiftUI

enum MeasurementSystem: String, Codable, Identifiable, CaseIterable, Equatable {
  case metric
  case imperial

  var id: MeasurementSystem { self }
}


extension EnvironmentValues {
  @Entry var measurementSystem = MeasurementSystem.metric
}


extension View {
  func measurementSystem(_ measurementSystem: MeasurementSystem) -> some View {
    environment(\.measurementSystem, measurementSystem)
  }
}


extension Scene {
  func measurementSystem(_ measurementSystem: MeasurementSystem) -> some Scene {
    environment(\.measurementSystem, measurementSystem)
  }
}
