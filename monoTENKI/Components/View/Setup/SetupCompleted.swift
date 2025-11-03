//
// SetupCompleted.swift
// monoTENKI
//
// Created by Barreloofy on 11/1/25 at 5:27 PM
//

import SwiftUI

extension EnvironmentValues {
  @Entry var setupCompleted = false
}


extension View {
  func setupCompleted(_ setupCompleted: Bool) -> some View {
    environment(\.setupCompleted, setupCompleted)
  }
}


extension Scene {
  func setupCompleted(_ setupCompleted: Bool) -> some Scene {
    environment(\.setupCompleted, setupCompleted)
  }
}
