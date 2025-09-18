//
// UnitSettings.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:51 PM
//

import SwiftUI

struct UnitSettings: View {
  @AppStorage(.key(.userModifiedMeasurementSystem)) private var userModifiedMeasurementSystem = false
  @AppStorage(.key(.measurementSystemInUse)) private var measurementSystemInUse = MeasurementSystem.metric

  var body: some View {
    SettingsDetailView(
      category: "Units",
      icon: "ruler.fill",
      description: "Select your preferred temperature unit to align weather information with your personal preferences.",
      items: MeasurementSystem.allCases,
      match: measurementSystemInUse) { value in
        setEnvironment(.measurementSystemInUse, value: value)
      }
  }
}


#Preview {
  UnitSettings()
    .configureApp()
    .sheetController(SettingsController())
}
