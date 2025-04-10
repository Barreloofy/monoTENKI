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

  @AppStorage("measurementSystemUsed") private var measurementSystemUsed = MeasurementSystem.metric
  @State private var noPermission = false

  var body: some View {
    VStack {

      ZStack {
        Text("Settings")
        AlignedHStack(alignment: .trailing) {
          Button(
            action: { dismiss() },
            label: {
              XIcon()
                .stroke(lineWidth: 3)
                .frame(width: 20, height: 20)
            })
        }
      }
      .font(.title)
      .fontWeight(.bold)
      .padding(.bottom)

      ZStack {
        AlignedHStack(alignment: .leading) { Text("Measurement:") }
          .font(.headline)

        MeasurementSystemCell(measurement: .metric)
          .onTapGesture { measurementSystemUsed = .metric }

        AlignedHStack(alignment: .trailing) {
          MeasurementSystemCell(measurement: .imperial)
            .onTapGesture { measurementSystemUsed = .imperial }
        }
      }

      permissionInfo

      Spacer()
    }
    .padding()
    .onAppear { measurementSystemUsed = measurementSystem }
    .task(id: scenePhase) {
      guard scenePhase == .active else { return }
      noPermission = await !CLServiceSession.getAuthorization() ? true : false
    }
  }


  @ViewBuilder private var permissionInfo: some View {
    if noPermission {
      Text("No permission to use your location currently, enable location to receive the most accurate weather")
        .font(.footnote)
        .multilineTextAlignment(.center)
        .padding(.top)
      Link("Open Settings App", destination: URL(string: UIApplication.openSettingsURLString)!)
        .buttonStyle(.bordered)
        .fontWeight(.bold)
    }
  }
}
