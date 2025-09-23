//
// SettingsIconConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 9/20/25 at 3:12 PM
//

import SwiftUI

struct SettingsIconConfiguration: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.title2)
      .fontWeight(.regular)
  }
}


extension View {
  func configureSettingsIcon() -> some View {
    modifier(SettingsIconConfiguration())
  }
}
