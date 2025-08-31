//
// AppConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 5/31/25 at 4:56 PM
//

import SwiftUI

struct AppConfiguration: ViewModifier {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.nightVision) private var nightVision
  @StyleMode private var styleMode

  func body(content: Content) -> some View {
    content
      .bodyFont()
      .fontDesign(.monospaced)
      .fontWeight(.bold)
      .textCase(.uppercase)
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .preferredColorScheme($styleMode)
      .foregroundStyle(styleMode)
      .tint(styleMode)
      .animation(reduceMotion ? nil : .default, value: nightVision)
      .animation(reduceMotion ? nil : .default, value: colorScheme)
      .dynamicTypeSize(...DynamicTypeSize.large)
      .modelContainer(for: Location.self)
  }
}


extension View {
  func configureApp() -> some View {
    modifier(AppConfiguration())
  }
}
