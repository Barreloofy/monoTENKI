//
// SubtitleFont\.swift
// monoTENKI
//
// Created by Barreloofy on 7/18/25 at 10:30 AM
//

import SwiftUI

struct SubtitleFont: ViewModifier {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  func body(content: Content) -> some View {
    content
      .font(horizontalSizeClass == .compact ? .title3 : .title)
  }
}


extension View {
  func subtitleFont() -> some View {
    modifier(SubtitleFont())
  }
}
