//
// ConfigureFont.swift
// monoTENKI
//
// Created by Barreloofy on 5/31/25 at 4:56 PM
//

import SwiftUI

struct ConfigureFont: ViewModifier {
  func body(content: Content) -> some View {
    content
      .textCase(.uppercase)
      .fontDesign(.monospaced)
      .fontWeight(.bold)
      .dynamicTypeSize(...DynamicTypeSize.large)
  }
}


extension View {
  func configureFont() -> some View {
    modifier(ConfigureFont())
  }
}
