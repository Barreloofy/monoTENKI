//
// SheetConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/15/25 at 11:37 PM
//

import SwiftUI

struct SheetConfiguration: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  let control: Binding<Bool>

  func body(content: Content) -> some View {
    content
      .presentationBackground(colorScheme.background)
      .minimumScaleFactor(1)
      .dynamicTypeSize(...DynamicTypeSize.large)
      .environment(SheetController(present: control))
  }
}


extension View {
  func configureSheet(_ control: Binding<Bool> = .constant(true)) -> some View {
    modifier(SheetConfiguration(control: control))
  }
}
