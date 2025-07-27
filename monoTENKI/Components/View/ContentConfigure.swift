//
// ContentConfigure.swift
// monoTENKI
//
// Created by Barreloofy on 5/31/25 at 4:56 PM
//

import SwiftUI

struct ContentConfigure: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  func body(content: Content) -> some View {
    content
      .fontDesign(.monospaced)
      .fontWeight(.bold)
      .textCase(.uppercase)
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .dynamicTypeSize(...DynamicTypeSize.large)
      .foregroundStyle(colorScheme.foreground)
      .tint(colorScheme.foreground)
  }
}


extension View {
  func contentConfigure() -> some View {
    modifier(ContentConfigure())
  }
}
