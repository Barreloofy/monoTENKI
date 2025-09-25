//
// AsyncOnChange.swift
// monoTENKI
//
// Created by Barreloofy on 6/27/25 at 2:40 PM
//

import SwiftUI

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
  /// Adds an asynchronous task to perform on change of the specified value.
  ///
  /// After the value of `id` has changed and before the action closure is executed,
  /// signals cancellation of the previous action.
  ///
  /// - Parameters:
  ///   - id: The value to observe for changes, must conform to Equatable.
  ///   - action: An asynchronous closure that is called after the value of `id` has changed.
  func asyncOnChange(id: some Equatable, _ action: @escaping () async -> Void) -> some View {
    modifier(AsyncOnChange(id: id, action: action))
  }
}
