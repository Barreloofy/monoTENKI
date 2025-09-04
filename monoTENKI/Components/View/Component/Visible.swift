//
// Visible.swift
// monoTENKI
//
// Created by Barreloofy on 5/3/25.
//

import SwiftUI

struct Visible: ViewModifier {
  let visible: Bool

  func body(content: Content) -> some View {
    if visible { content }
  }
}

extension View {
  /// Presents this view conditionally.
  ///
  /// > Important: `visible(_:)` modifies the view hierarchy, which incurs a performance cost.
  /// - Parameter visible: A value that determines whether the view is visible.
  func visible(_ visible: Bool) -> some View {
    modifier(Visible(visible: visible))
  }
}
