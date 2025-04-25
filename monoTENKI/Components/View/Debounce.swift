//
//  Debounce.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/22/25.
//

import SwiftUI
/// Simple debounce implantation for SwiftUI,
/// makes use of the task(id:priority:_:) method and ViewModifier protocol.
/// The task property is bound to the MainActor, UI dependent properties can savely be accessed and modified.
struct Debounce<ID: Equatable>: ViewModifier {
  let id: ID
  let duration: Duration
  let task: @MainActor () async -> Void

  func body(content: Content) -> some View {
    content
      .task(id: id) {
        do {
          try await Task.sleep(for: duration)
          await task()
        } catch {}
      }
  }
}


extension View {
  /// Executes the task after the suspension period has elapsed, if the id changes before that, the task gets cancelled
  func debounce<ID: Equatable>(
    id: ID,
    duration: Duration,
    task: @MainActor @escaping () async -> Void) -> some View {
      modifier(
        Debounce(
          id: id,
          duration: duration,
          task: task))
  }
}
