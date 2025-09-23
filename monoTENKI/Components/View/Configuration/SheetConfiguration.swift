//
// SheetConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/15/25 at 11:37 PM
//

import SwiftUI

struct SheetConfiguration: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  func body(content: Content) -> some View {
    content
      .presentationBackground(colorScheme.background)
      .minimumScaleFactor(1)
      .dynamicTypeSize(...DynamicTypeSize.large)
  }
}


extension View {
  func configureSheet() -> some View {
    modifier(SheetConfiguration())
  }
}
