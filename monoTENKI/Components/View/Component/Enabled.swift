//
// Enabled.swift
// monoTENKI
//
// Created by Barreloofy on 9/4/25 at 1:09 PM
//

import SwiftUI

struct Enabled: ViewModifier {
  let enabled: Bool

  func body(content: Content) -> some View {
    content
      .disabled(!enabled)
  }
}

extension View {
  /// Adds a condition that controls whether users can interact with this view.
  /// - Parameter enabled: A value that determines whether the view can be interacted with.
  func enabled(_ enabled: Bool) -> some View {
    modifier(Enabled(enabled: enabled))
  }
}
