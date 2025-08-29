//
// BodyFont.swift
// monoTENKI
//
// Created by Barreloofy on 7/17/25 at 10:02 PM
//

import SwiftUI

struct BodyFont: ViewModifier {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  func body(content: Content) -> some View {
    content
      .font(horizontalSizeClass == .compact ? .body : .title3)
  }
}


extension View {
  func bodyFont() -> some View {
    modifier(BodyFont())
  }
}
