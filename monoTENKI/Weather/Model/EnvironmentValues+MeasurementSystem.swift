//
//  EnvironmentValues+MeasurementSystem.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/23/25 at 5:49 PM.
//

import SwiftUI
// The environment-value that serves as the source of truth for whether to use metric or imperial
extension EnvironmentValues {
  @Entry var measurementSystem = MeasurementSystem.metric
}


enum MeasurementSystem: String, CaseIterable, Identifiable {
  case metric
  case imperial

  var id: MeasurementSystem { self }
}
