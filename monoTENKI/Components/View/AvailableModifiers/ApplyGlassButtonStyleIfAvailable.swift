//
// ApplyGlassButtonStyleIfAvailable.swift
// monoTENKI
//
// Created by Barreloofy on 9/19/25 at 6:02 PM
//

import SwiftUI

struct ApplyGlassButtonStyleIfAvailable: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 26.0, *) {
      content
        .buttonStyle(.glass)
    } else {
      content
    }
  }
}


extension View {
  func applyGlassButtonStyleIfAvailable() -> some View {
    modifier(ApplyGlassButtonStyleIfAvailable())
  }
}
