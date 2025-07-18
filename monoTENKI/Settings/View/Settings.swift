//
//  Settings.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 3:16 PM.
//

import SwiftUI

struct Settings: View {
  @Environment(\.dismiss) private var dismiss

  @AppStorage(StorageKeys.apiSourceInUse.rawValue) private var apiSourceInUse = APISource.weatherAPI
  @AppStorage(StorageKeys.userModifiedMeasurementSystem.rawValue) var userModifiedMeasurementSystem = false
  @AppStorage(StorageKeys.measurementSystemInUse.rawValue) private var measurementSystemInUse = MeasurementSystem.metric

  var body: some View {
    VStack(spacing: 25) {
      Row(
        center: { Text("Settings") },
        trailing: {
          Button(
            action: { dismiss() },
            label: { DismissIcon().styled() })
        })
      .topBarConfiguration()

      Row(
        leading: { Text("Measurement:") },
        center: {
          Text(MeasurementSystem.metric.rawValue)
            .selectedStyle(target: MeasurementSystem.metric, value: $measurementSystemInUse) {
              guard !userModifiedMeasurementSystem else { return }
              userModifiedMeasurementSystem = true
            }
        },
        trailing: {
          Text(MeasurementSystem.imperial.rawValue)
            .selectedStyle(target: MeasurementSystem.imperial, value: $measurementSystemInUse) {
              guard !userModifiedMeasurementSystem else { return }
              userModifiedMeasurementSystem = true
            }
        })

      Row(
        leading: { Text("Source:") },
        center: {
          Text(APISource.weatherAPI.rawValue)
            .selectedStyle(target: APISource.weatherAPI, value: $apiSourceInUse)
        },
        trailing: {
          Text(APISource.accuWeather.rawValue)
            .selectedStyle(target: APISource.accuWeather, value: $apiSourceInUse)
        })

      Spacer()
    }
    .fontWeight(.medium)
    .padding()
  }
}
