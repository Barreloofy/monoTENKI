//
//  Settings.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/28/25 at 3:16 PM.
//

import SwiftUI

struct Settings: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.apiSourceInUse) private var apiSourceInUse
  @Environment(\.measurementSystemInUse) private var measurementSystemInUse

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
                      .configureSettingsIcon()
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
                      .configureSettingsIcon()
                  })
              })
          })

        NightToggle()

        Spacer()
      }
      .configureNavigationBar()
      .fontWeight(.medium)
      .padding()
    }
    .tint(colorScheme.foreground)
  }
}


#Preview {
  Settings()
    .configureApp()
    .environment(SheetController(present: .constant(true)))
}
