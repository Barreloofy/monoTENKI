//
// PrimaryFont.swift
// monoTENKI
//
// Created by Barreloofy on 7/17/25 at 3:27 PM
//

import SwiftUI

struct PrimaryFont: ViewModifier {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  func body(content: Content) -> some View {
    content
      .font(.system(size: horizontalSizeClass == .compact ? 60 : 90))
  }
}


extension View {
  func primaryFont() -> some View {
    modifier(PrimaryFont())
  }
}
