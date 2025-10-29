//
// UserModifiedMeasurementSystem.swift
// monoTENKI
//
// Created by Barreloofy on 10/29/25 at 2:34 PM
//

import SwiftUI

extension EnvironmentValues {
  @Entry var userModifiedMeasurementSystem = false
}


extension View {
  func modifiedMeasurementSystem(_ userModifiedMeasurementSystem: Bool) -> some View {
    environment(\.userModifiedMeasurementSystem, userModifiedMeasurementSystem)
  }
}


extension Scene {
  func modifiedMeasurementSystem(_ userModifiedMeasurementSystem: Bool) -> some Scene {
    environment(\.userModifiedMeasurementSystem, userModifiedMeasurementSystem)
  }
}
