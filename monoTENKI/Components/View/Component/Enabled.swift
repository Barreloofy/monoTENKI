//
// Enabled.swift
// monoTENKI
//
// Created by Barreloofy on 5/3/25.
//

import SwiftUI

extension View {
  /// Conditionally present the attached view.
  /// - Parameter condition: The value to control presentation.
  @ViewBuilder func enabled(_ enabled: Bool) -> some View {
    if enabled { self }
  }
}
