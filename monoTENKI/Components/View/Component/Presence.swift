//
// Presence.swift
// monoTENKI
//
// Created by Barreloofy on 9/4/25 at 5:51 PM
//

import SwiftUI

struct Presence: ViewModifier {
  let active: Bool

  func body(content: Content) -> some View {
    content
      .visible(active)
      .enabled(active)
  }
}


extension View {
  /// Adds a condition that controls whether the view is visible and can be interacted with.
  ///
  /// The rationale behind this modifier is to provide a streamlined way to add or remove a view from the view hierarchy,
  /// with the possibility of this transition being animated.
  /// While at the same time, preventing any interaction while the view is in a transient state.
  ///
  /// - Parameter active: A value that determines whether the view is active.
  func presence(active: Bool) -> some View {
    modifier(Presence(active: active))
  }
}
