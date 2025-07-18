//
// HighlightFont.swift
// monoTENKI
//
// Created by Barreloofy on 7/17/25 at 9:42 PM
//

import SwiftUI

struct HighlightFont: ViewModifier {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  func body(content: Content) -> some View {
    content
      .font(horizontalSizeClass == .compact ? .title : .largeTitle)
  }
}


extension View {
  func highlightFont() -> some View {
    modifier(HighlightFont())
  }
}
