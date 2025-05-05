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

  @AppStorage("measurementSystem") private var measurementSystemInUse = MeasurementSystem.metric
  @AppStorage("apiSource") private var apiSourceInUse = APISource.weatherApi
  @State private var noPermission = false

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
          Text(APISource.weatherApi.rawValue)
            .selectedStyle(target: APISource.weatherApi, value: $apiSourceInUse)
        },
        trailing: {
          Text(APISource.accuWeather.rawValue)
            .selectedStyle(target: APISource.accuWeather, value: $apiSourceInUse)
        })
      .font(.subheadline)

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
      LocationAccessError()
      .multilineTextAlignment(.center)
    }
  }
}
