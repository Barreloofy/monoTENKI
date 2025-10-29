//
// UnitSettings.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:51 PM
//

import SwiftUI

struct UnitSettings: View {
  @Environment(\.measurementSystemInUse) private var measurementSystemInUse
  @Environment(\.userModifiedMeasurementSystem) private var userModifiedMeasurementSystem

  var body: some View {
    SettingsDetailView(
      category: "Units",
      icon: "ruler.fill",
      description: "Select your preferred temperature unit to align weather information with your personal preferences.",
      items: MeasurementSystem.allCases,
      match: measurementSystemInUse) { value in
        if !userModifiedMeasurementSystem {
          UserDefaults.standard.set(true, forKey: StorageValues.userModifiedMeasurementSystem.key)
        }
        UserDefaults.standard.setRawRepresentable(\.measurementSystemInUse, value: value)
      }
  }
}


#Preview {
  UnitSettings()
    .configureApp()
    .sheetController(SettingsController())
}
