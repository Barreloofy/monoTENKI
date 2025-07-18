//
// TextConfigure.swift
// monoTENKI
//
// Created by Barreloofy on 5/31/25 at 4:56 PM
//

import SwiftUI

struct TextConfigure: ViewModifier {
  func body(content: Content) -> some View {
    content
      .fontDesign(.monospaced)
      .fontWeight(.bold)
      .textCase(.uppercase)
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .dynamicTypeSize(...DynamicTypeSize.large)
  }
}


extension View {
  func textConfigure() -> some View {
    modifier(TextConfigure())
  }
}
