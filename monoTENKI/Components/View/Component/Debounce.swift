//
// Debounce.swift
// monoTENKI
//
// Created by Barreloofy on 4/22/25.
//

import SwiftUI

struct Debounce<ID: Equatable>: ViewModifier {
  @State private var oldID: ID?
  
  let id: ID
  let duration: TimeInterval
  let action: () async -> Void
  
  private var delay: Bool {
    get async {
      do {
        try await Task.sleep(for: .seconds(duration))
        return true
      } catch {
        return false
      }
    }
  }
  
  func body(content: Content) -> some View {
    content
      .task(id: id) {
        defer { oldID = id }
        
        guard
          let oldID,
          oldID != id
        else { return }
        
        guard await delay else { return }
        
        await action()
      }
  }
}


#Preview {
  @Previewable @State var text = ""
  
  Form {
    TextField("Enter Text Here...", text: $text)
      .debounce(id: text, duration: 1) {
        print("Value: \(text)")
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
  /// - Parameters:
  ///   - id: The value to observe for changes.
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
