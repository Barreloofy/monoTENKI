//
// SpeedView.swift
// monoTENKI
//
// Created by Barreloofy on 6/1/25 at 9:24 PM
//

import SwiftUI

struct SpeedView: View {
  @Environment(\.measurementSystem) private var measurementSystem

  let speed: Double
  let text: String
  let accessibilityText: String

  init(_ speed: Double) {
    self.speed = speed
    self.text = ""
    self.accessibilityText = ""
  }

  init(_ text: String, _ speed: Double, accessibilityText: String? = nil) {
    self.speed = speed
    self.text = text + " "
    self.accessibilityText = accessibilityText ?? text
  }

  var body: some View {
    Text(String(text + speed.SpeedFormatter(measurementSystem)))
      .accessibilityLabel(
        accessibilityText + speed.SpeedFormatter(
          measurementSystem,
          unitWidth: .wide))
  }
}
