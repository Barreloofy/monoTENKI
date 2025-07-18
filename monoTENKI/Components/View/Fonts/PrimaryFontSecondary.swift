//
// PrimaryFontSecondary.swift
// monoTENKI
//
// Created by Barreloofy on 7/17/25 at 3:35 PM
//

import SwiftUI

struct PrimaryFontSecondary: ViewModifier {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  func body(content: Content) -> some View {
    content
      .font(.system(size: horizontalSizeClass == .compact ? 30 : 45))
  }
}


extension View {
  func primaryFontSecondary() -> some View {
    modifier(PrimaryFontSecondary())
  }
}
