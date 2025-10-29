//
// NavigationBarConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 9/20/25 at 2:49 PM
//

import SwiftUI

struct NavigationBarConfiguration: ViewModifier {
  @Environment(\.dismiss) private var dismiss

  let enabled: Bool

  func body(content: Content) -> some View {
    if enabled {
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
  func configureNavigationBar(enabled: Bool = true) -> some View {
    modifier(NavigationBarConfiguration(enabled: enabled))
  }
}
