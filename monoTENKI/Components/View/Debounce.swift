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
  @State private var initID: ID?

  let id: ID
  let duration: Duration
  let action: @MainActor () async -> Void

  func body(content: Content) -> some View {
    content
      .onAppear { initID = id }
      .task(id: id) {
        guard id != initID else { return }
        do {
          try await Task.sleep(for: duration)
          await action()
        } catch {}
      }
  }
}


extension View {
  /// Executes the task after the suspension period has elapsed, if the id changes before that, the task gets cancelled.
  /// - Parameters:
  ///   - id: The value to observe for changes, id must conform to Equatable.
  ///   - duration: The length of the suspension period.
  ///   - action: A async closure that is called after the suspension period has elapsed.
  /// - Returns:
  /// A view that runs the specified action asynchronously before the view appears, or restarts the task when the id value changes.
  func debounce<ID: Equatable>(
    id: ID,
    duration: Duration = .seconds(0.5),
    action: @MainActor @escaping () async -> Void) -> some View {
      modifier(
        Debounce(
          id: id,
          duration: duration,
          action: action))
  }
}
