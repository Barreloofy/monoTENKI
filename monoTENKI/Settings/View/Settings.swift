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
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    NavigationStack {
      VStack(spacing: 25) {
        NavigationLink(
          destination: { SourceSettings() },
          label: {
            LabeledContent(
              content: {
                Text(apiSourceInUse.rawValue)
                  .selectedStyle()
                  .accessibilityLabel(apiSourceInUse.accessibilityPronunciation)
              },
              label: {
                Label(
                  title: { Text("Source:") },
                  icon: {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                      .font(.title2)
                      .fontWeight(.regular)
                  })
              })
          })

        NavigationLink(
          destination: { UnitSettings() },
          label: {
            LabeledContent(
              content: {
                Text(measurementSystemInUse.rawValue)
                  .selectedStyle()
              },
              label: {
                Label(
                  title: { Text("Units:") },
                  icon: {
                    Image(systemName: "ruler.fill")
                      .font(.title2)
                      .fontWeight(.regular)
                  })
              })
          })

        NightToggle()

        Spacer()
      }
      .toolbarRole(.navigationStack)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(
            action: { dismiss() },
            label: {
              Image(systemName: "xmark")
                .foregroundStyle(colorScheme.foreground)
            })
        }
      }
      .padding()
    }
    .fontWeight(.medium)
    .tint(colorScheme.foreground)
  }
}


#Preview {
  Settings()
    .configureApp()
    .sheetController(SettingsController())
}
