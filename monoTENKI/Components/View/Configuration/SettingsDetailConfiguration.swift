//
// SettingsDetailConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:14 PM
//

import SwiftUI

struct SettingsDetailConfiguration: ViewModifier {
  @Environment(SheetController.self) private var sheetController
  @Environment(\.colorScheme) private var colorScheme

  func body(content: Content) -> some View {
    content
      .background(colorScheme.background)
      .toolbarRole(.navigationStack)
      .toolbar {
        Close(action: sheetController.present.wrappedValue.toggle())
      }
  }
}


extension View {
  func configureSettingsDetail() -> some View {
    modifier(SettingsDetailConfiguration())
  }
}
