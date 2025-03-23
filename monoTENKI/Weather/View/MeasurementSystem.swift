//
//  MeasurementSystem.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/23/25 at 5:49 PM.
//

import SwiftUI

enum MeasurementSystem {
  case metric
  case Imperial
}

// MARK: - The Environment-Value that serves as the source of truth for whether to use metric or imperial
extension EnvironmentValues {
  @Entry var measurementSystem = MeasurementSystem.metric
}
