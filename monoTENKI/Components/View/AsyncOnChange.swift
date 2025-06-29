//
// AsyncOnChange.swift
// monoTENKI
//
// Created by Barreloofy on 6/27/25 at 2:40 PM
//

import SwiftUI

/// Executes an asynchronous closure on change of the specified value,
/// if specified value changes before the asynchronous closure is done executing, signals cancellation.
struct AsyncOnChange<T: Equatable>: ViewModifier {
  @State private var task: Task<Void, Never>?

  let id: T
  let action: () async -> Void

  func body(content: Content) -> some View {
    content
      .onChange(of: id) {
        task?.cancel()
        task = Task { await action() }
      }
  }
}


extension View {
  /// Executes 'action' asynchronously on change of 'id', cancels previous action.
  /// - Parameters:
  ///   - id: The value to observe for changes, 'id' must conform to Equatable.
  ///   - action: An async closure that is called after 'id' has changed.
  /// - Returns: A view that executes an action when 'id' changes.
  func asyncOnChange<T: Equatable>(id: T, _ action: @escaping () async -> Void) -> some View {
    modifier(AsyncOnChange(id: id, action: action))
  }
}
