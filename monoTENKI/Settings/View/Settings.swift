//
//  Settings.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 3:16 PM.
//

import SwiftUI

struct Settings: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.apiSource) private var apiSourceInUse
  @Environment(\.measurementSystem) private var measurementSystemInUse

  var body: some View {
    NavigationStack {
      VStack(spacing: 25) {
        Row(
          center: { Text("Settings") },
          trailing: {
            Button(
              action: { dismiss() },
              label: {
                Image(systemName: "xmark")
                  .fontWeight(.regular)
              })
          })
        .topBarConfiguration()

        NavigationLink(
          destination: { SourceView() },
          label: {
            HStack {
              Label(
                title: { Text("Source:") },
                icon: {
                  Image(systemName: "antenna.radiowaves.left.and.right")
                    .styled(size: 25)
                })

              Spacer()

              Text(apiSourceInUse.rawValue)
                .selectedStyle()
                .accessibilityLabel(apiSourceInUse.accessibilityPronunciation)
            }
          })

        NavigationLink(
          destination: { MeasurementView() },
          label: {
            HStack {
              Label(
                title: { Text("Units:") },
                icon: {
                  Image(systemName: "ruler.fill")
                    .styled(size: 25)
                })

              Spacer()

              Text(measurementSystemInUse.rawValue)
                .selectedStyle()
            }
          })

        NightToggle()

        Spacer()
      }
      .padding()
    }
    .fontWeight(.medium)
  }
}
