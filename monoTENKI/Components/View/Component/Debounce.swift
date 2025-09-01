//
// Debounce.swift
// monoTENKI
//
// Created by Barreloofy on 4/22/25.
//

import SwiftUI

struct Debounce<ID: Equatable>: ViewModifier {
  @State private var initialID: ID?

  let id: ID
  let duration: TimeInterval
  let action: () async -> Void

  func body(content: Content) -> some View {
    content
      .onAppear { initialID = id }
      .task(id: id) {
        guard id != initialID else { return }

        guard (try? await Task.sleep(for: .seconds(duration))) != nil else { return }

        await action()
      }
  }
}


extension View {
  /// Calls the action closure after the suspension period has elapsed and the specified value has changed.
  ///
  /// Starts a suspension period after the specified value has changed,
  /// once the suspension period has elapsed, executes the asynchronous closure.
  /// If the specified value changes, restarts the suspension period and cancels the current task.
  ///
  /// > Important:
  /// `id`'s value must not be equal to its initial value to trigger debounce.
  ///
  /// - Parameters:
  ///   - id: The value to observe for changes, must conform to Equatable.
  ///   - duration: The length of the suspension period.
  ///   - action: An async closure that is called after the suspension period has elapsed.
  /// - Returns: A view that executes an action when `id` changes after a certain time has elapsed.
  func debounce(
    id: some Equatable,
    duration: TimeInterval = 0.5,
    action: @escaping () async -> Void) -> some View {
      modifier(
        Debounce(
          id: id,
          duration: duration,
          action: action))
    }
}
