//
// GlassBackground.swift
// monoTENKI
//
// Created by Barreloofy on 9/18/25 at 5:27 PM
//

import SwiftUI

struct GlassBackground: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 26.0, *) {
      content
        .glassEffect(in: RoundedRectangle(cornerRadius: 8))
    } else {
      content
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
  }
}


extension View {
  func glassBackground() -> some View {
    modifier(GlassBackground())
  }
}
