//
// AsyncOnChange.swift
// monoTENKI
//
// Created by Barreloofy on 6/27/25 at 2:40 PM
//

import SwiftUI

struct AsyncOnChange<ID: Equatable>: ViewModifier {
  @State private var task: Task<Void, Never>?

  let id: ID
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
  /// Adds an asynchronous task to perform on change of the specified value.
  ///
  /// After the value of `id` has changed and before the action closure is executed,
  /// signals cancellation to the previous task.
  ///
  /// - Parameters:
  ///   - id: The value to observe for changes.
  ///   - action: An asynchronous closure to run when the value changes.
  func asyncOnChange(
    id: some Equatable,
    _ action: @escaping () async -> Void)
  -> some View {
    modifier(AsyncOnChange(id: id, action: action))
  }
}
