//
// NavigationBarConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 9/20/25 at 2:49 PM
//

import SwiftUI

struct NavigationBarConfiguration: ViewModifier {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.colorScheme) private var colorScheme

  let enabled: Bool

  func body(content: Content) -> some View {
    if enabled {
      content
        .toolbarRole(.navigationStack)
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Button(
              action: { dismiss() },
              label: {
                Image(systemName: "xmark")
                  .fontWeight(.medium)
                  .foregroundStyle(colorScheme.foreground)
              })
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
