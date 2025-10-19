//
// SettingsDetailConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:14 PM
//

import SwiftUI

struct SettingsDetailConfiguration: ViewModifier {
  @Environment(SettingsController.self) private var settingsController
  @Environment(\.colorScheme) private var colorScheme

  func body(content: Content) -> some View {
    content
      .background(colorScheme.background)
      .toolbarRole(.navigationStack)
      .toolbar {
        ToolbarItem(placement: .navigation) {
          Button(
            action: { settingsController() },
            label: { Image(systemName: "xmark") })
          .foregroundStyle(colorScheme.foreground)
        }
      }
  }
}


extension View {
  func configureSettingsDetail() -> some View {
    modifier(SettingsDetailConfiguration())
  }
}
