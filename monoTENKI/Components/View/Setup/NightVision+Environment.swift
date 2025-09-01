//
// EnvironmentNightVision.swift
// monoTENKI
//
// Created by Barreloofy on 7/29/25 at 12:34 PM
//

import SwiftUI

extension EnvironmentValues {
  @Entry var nightVision = false
}


extension View {
  func nightVision(_ nightVision: Bool) -> some View {
    environment(\.nightVision, nightVision)
  }
}


extension Scene {
  func nightVision(_ nightVision: Bool) -> some Scene {
    environment(\.nightVision, nightVision)
  }
}
