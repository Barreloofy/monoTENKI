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
  @Environment(\.dismiss) private var dismiss

  @AppStorage("measurementSystem") private var measurementUsed = MeasurementSystem.metric
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
      .padding(.vertical)

      ZStack {
        AlignedHStack(alignment: .leading) { Text("Measurement:") }
          .font(.headline)

        MeasurementSystemCell(measurement: .metric)
          .onTapGesture { measurementUsed = .metric }

        AlignedHStack(alignment: .trailing) {
          MeasurementSystemCell(measurement: .imperial)
            .onTapGesture { measurementUsed = .imperial }
        }
      }
      .padding(.bottom, 50)

      permissionInfo

      Spacer()
    }
    .padding(.horizontal)
    .onAppear { measurementUsed = measurementSystem }
    .task { if await !CLServiceSession.getAuthorization() { noPermission = true } }
  }


  @ViewBuilder private var permissionInfo: some View {
    if noPermission {
      Group {
        Text("monoTENKI has no permission to use your location currently, enable location to receive the most accurate weather")
          .multilineTextAlignment(.center)
        Link("Open Settings App", destination: URL(string: UIApplication.openSettingsURLString)!)
          .buttonStyle(.bordered)
          .font(.callout)
          .fontWeight(.bold)
      }
      .font(.footnote)
    }
  }
}
