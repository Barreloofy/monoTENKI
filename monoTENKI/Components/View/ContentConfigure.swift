//
// ContentConfigure.swift
// monoTENKI
//
// Created by Barreloofy on 5/31/25 at 4:56 PM
//

import SwiftUI

struct ContentConfigure: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.nightVision) private var nightVision
  @ColorSchemeWrapper private var colorSchemeWrapper

  func body(content: Content) -> some View {
    content
      .fontDesign(.monospaced)
      .fontWeight(.bold)
      .textCase(.uppercase)
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .preferredColorScheme($colorSchemeWrapper)
      .foregroundStyle(colorSchemeWrapper)
      .tint(colorSchemeWrapper)
      .animation(.default, value: nightVision)
      .animation(.default, value: colorScheme)
      .dynamicTypeSize(...DynamicTypeSize.large)
  }
}


extension View {
  func contentConfigure() -> some View {
    modifier(ContentConfigure())
  }
}
