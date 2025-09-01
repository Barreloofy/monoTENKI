//
// SettingsDetailConfiguration.swift
// monoTENKI
//
// Created by Barreloofy on 7/27/25 at 1:14 PM
//

import SwiftUI

struct SettingsDetailConfiguration: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.dismiss) private var dismiss

  func body(content: Content) -> some View {
    content
      .padding()
      .background(colorScheme.background)
      .toolbarVisibility(.hidden, for: .navigationBar)
      .gesture(
        DragGesture(minimumDistance: 50)
          .onChanged { value in
            guard value.startLocation.x < 20,
                  value.translation.width > 60
            else { return }
            dismiss()
          })
  }
}


extension View {
  func configureSettingsDetail() -> some View {
    modifier(SettingsDetailConfiguration())
  }
}
