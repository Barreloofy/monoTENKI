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
  func asyncOnChange<T: Equatable>(id: T, _ action: @escaping () async -> Void) -> some View {
    modifier(AsyncOnChange(id: id, action: action))
  }
}
