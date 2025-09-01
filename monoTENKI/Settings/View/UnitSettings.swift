//
// UnitSettings.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:51 PM
//

import SwiftUI

struct UnitSettings: View {
  @AppStorage(StorageKeys.userModifiedMeasurementSystem.rawValue) private var userModifiedMeasurementSystem = false
  @AppStorage(StorageKeys.measurementSystemInUse.rawValue) private var measurementSystemInUse = MeasurementSystem.metric

  var body: some View {
    VStack(spacing: 50) {
      SettingsNavigationBar(title: "Units")

      LazyVGrid(columns: .twoColumnLayout) {
        ForEach(MeasurementSystem.allCases) { system in
          Text(system.rawValue)
            .selectedStyle(target: system, value: $measurementSystemInUse)
        }
      }
      .onChange(of: measurementSystemInUse) {
        guard !userModifiedMeasurementSystem else { return }
        userModifiedMeasurementSystem = true
      }

      Spacer()
    }
    .configureSettingsDetail()
  }
}
