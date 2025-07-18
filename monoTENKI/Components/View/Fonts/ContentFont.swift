//
// ContentFont.swift
// monoTENKI
//
// Created by Barreloofy on 7/17/25 at 10:02 PM
//

import SwiftUI

struct ContentFont: ViewModifier {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  func body(content: Content) -> some View {
    content
      .font(horizontalSizeClass == .compact ? .body : .title3)
  }
}


extension View {
  func contentFont() -> some View {
    modifier(ContentFont())
  }
}
