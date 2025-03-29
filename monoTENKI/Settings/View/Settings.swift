//
//  Settings.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 3:16 PM.
//

import SwiftUI
import CoreLocation
import os

struct Settings: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.measurementSystem) private var measurementSystem

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
      .font(.system(.title, design: .monospaced, weight: .bold))
      .padding(.bottom, 50)

      ZStack {
        AlignedHStack(alignment: .leading) { Text("Measurement:") }
          .font(.system(.headline, design: .monospaced, weight: .medium))

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
    .padding()
    .onAppear { measurementUsed = measurementSystem }
    .task {
      do {
        let session = CLServiceSession(authorization: .whenInUse)

        for try await diagnostic in session.diagnostics {
          if diagnostic.authorizationDenied { noPermission = true }
          return
        }
      } catch {
        Logger.settings.error("\(error)")
      }
    }
  }


  @ViewBuilder private var permissionInfo: some View {
    if noPermission {
      Group {
        Text("monoTENKI has no permission to use your location currently, enable location to receive the most accurate weather")
          .multilineTextAlignment(.center)
        Link("Open Settings App", destination: URL(string: UIApplication.openSettingsURLString)!)
          .buttonStyle(.bordered)
          .font(.system(.callout, design: .monospaced, weight: .bold))
      }
      .font(.system(.footnote, design: .monospaced, weight: .medium))
    }
  }
}

// MARK: - Logger for 'Settings'
extension Logger {
  static fileprivate let settings = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Settings")
}
