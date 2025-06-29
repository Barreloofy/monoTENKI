//
//  Debounce.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/22/25.
//

import SwiftUI

/// Starts a suspension period after the specified value has changed,
/// after the suspension period has elapsed executes the asynchronous closure.
/// If the specified value changes, restarts the suspension period and cancels the current task.
struct Debounce<ID: Equatable>: ViewModifier {
  @State private var initialID: ID?

  let id: ID
  let duration: Duration
  let action: () async -> Void

  func body(content: Content) -> some View {
    content
      .onAppear { initialID = id }
      .task(id: id) {
        guard id != initialID else { return }

        guard let _ = try? await Task.sleep(for: duration) else { return }

        await action()
      }
  }
}


extension View {
  /// Executes 'action' after the suspension period has elapsed, if 'id' changes before that the task gets cancelled.
  /// - Parameters:
  ///   - id: The value to observe for changes, id must conform to Equatable.
  ///   - duration: The length of the suspension period.
  ///   - action: An async closure that is called after the suspension period has elapsed.
  /// - Returns: A view that executes an action when 'id' changes after a certain time has elapsed.
  func debounce<ID: Equatable>(
    id: ID,
    duration: Duration = .seconds(0.5),
    action: @escaping () async -> Void) -> some View {
      modifier(
        Debounce(
          id: id,
          duration: duration,
          action: action))
    }
}
