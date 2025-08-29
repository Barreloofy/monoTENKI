//
// FootnoteFont.swift
// monoTENKI
//
// Created by Barreloofy on 8/29/25 at 4:36 PM
//

import SwiftUI

struct FootnoteFont: ViewModifier {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  func body(content: Content) -> some View {
    content
      .font(horizontalSizeClass == .compact ? .footnote : .body)
  }
}


extension View {
  func footnoteFont() -> some View {
    modifier(FootnoteFont())
  }
}
