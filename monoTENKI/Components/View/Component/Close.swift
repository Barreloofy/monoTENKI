//
// Close.swift
// monoTENKI
//
// Created by Barreloofy on 10/26/25 at 10:43 PM
//

import SwiftUI

/// A dismiss button that runs an action on interaction.
struct Close: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.dismiss) private var dismiss

  /// The action closure to run.
  private let action: (() -> Void)?

  /// Configure `Close` with a custom action.
  /// - Parameter action: The specified action.
  init(action: @escaping () -> Void) {
    self.action = action
  }

  /// Configure `Close` with a custom action from an `autoclosure`.
  /// - Parameter action: The specified autoclosure.
  init(action: @autoclosure @escaping () -> Void) {
    self.action = action
  }

  /// The default `Close`, on tap dismisses the current view.
  init() {
    self.action = nil
  }

  var body: some View {
    let action = action ?? dismiss.callAsFunction

    Button(action: action) {
      Image(systemName: "xmark")
        .fontWeight(.medium)
        .foregroundStyle(colorScheme.foreground)
    }
  }
}


#Preview {
  Close(action: print("Hello, World!"))
}
