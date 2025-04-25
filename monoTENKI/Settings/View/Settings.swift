//
//  Settings.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 3:16 PM.
//

import SwiftUI
import CoreLocation

struct Settings: View {
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(\.scenePhase) private var scenePhase
  @Environment(\.dismiss) private var dismiss

  @AppStorage("measurementSystemInUse") private var measurementSystemInUse = MeasurementSystem.metric
  @State private var noPermission = false
  @State private var sourceInUse = Source.value

  var body: some View {
    VStack(spacing: 25) {
      Row(
        leading: {},
        center: { Text("Settings") },
        trailing: {
          Button(
            action: { dismiss() },
            label: { XIcon().iconStyleX })
        })
      .font(.title)
      .fontWeight(.bold)

       Row(
         leading: {
           Text("Measurement:")
             .font(.headline)
         },
         center: {
           Text(MeasurementSystem.metric.rawValue)
             .selectedStyle(target: MeasurementSystem.metric, value: $measurementSystemInUse)
         },
         trailing: {
           Text(MeasurementSystem.imperial.rawValue)
             .selectedStyle(target: MeasurementSystem.imperial, value: $measurementSystemInUse)
         })
       .font(.subheadline)

      Row(
        leading: {
          Text("Source:")
            .font(.headline)
        },
        center: {
          Text(APISource.WeatherAPI.rawValue)
            .selectedStyle(target: APISource.WeatherAPI, value: $sourceInUse)
        },
        trailing: {
          Text(APISource.AccuWeather.rawValue)
            .selectedStyle(target: APISource.AccuWeather, value: $sourceInUse)
        })
      .font(.subheadline)
      .onChange(of: sourceInUse) { Source.value = sourceInUse }

      permissionInfo

      Spacer()
    }
    .padding()
    .onAppear { measurementSystemInUse = measurementSystem }
    .task(id: scenePhase) {
      guard scenePhase == .active else { return }
      noPermission = await !CLServiceSession.getAuthorizationStatus() ? true : false
    }
  }


  @ViewBuilder private var permissionInfo: some View {
    if noPermission {
      LocationAccessError(
        message: "No permission to access location currently, enable location to receive the most accurate weather")
      .multilineTextAlignment(.center)
    }
  }
}
