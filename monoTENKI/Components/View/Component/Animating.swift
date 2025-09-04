//
// Animating.swift
// monoTENKI
//
// Created by Barreloofy on 8/29/25 at 7:56 PM
//

import SwiftUI

struct Animating<T: Equatable>: ViewModifier {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  let animation: Animation?
  let value: T

  func body(content: Content) -> some View {
    content
      .animation(reduceMotion ? nil : animation, value: value)
  }
}


extension View {
  /// Applies the given animation to this view when the specified value changes,
  /// if `accessibilityReduceMotion` is enabled, disables animation.
  /// - Parameters:
  ///   - value: A value to monitor for changes.
  ///   - animation: The animation to apply. If animation is nil, the view doesn’t animate.
  func animating(_ value: some Equatable, with animation: Animation?) -> some View {
    modifier(Animating(animation: animation, value: value))
  }
}
