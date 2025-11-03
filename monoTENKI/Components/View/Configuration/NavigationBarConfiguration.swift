//
// NavigationBarConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 9/20/25 at 2:49 PM
//

import SwiftUI

struct NavigationBarConfiguration: ViewModifier {
  @Environment(\.setupCompleted) private var setupCompleted
  @Environment(\.dismiss) private var dismiss

  func body(content: Content) -> some View {
    if setupCompleted {
      content
        .toolbarRole(.navigationStack)
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Close(action: dismiss())
          }
        }
    } else {
      content
    }
  }
}


extension View {
  func configureNavigationBar() -> some View {
    modifier(NavigationBarConfiguration())
  }
}
