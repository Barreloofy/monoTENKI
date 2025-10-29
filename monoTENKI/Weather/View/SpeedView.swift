//
// SpeedView.swift
// monoTENKI
//
// Created by Barreloofy on 6/1/25 at 9:24 PM
//

import SwiftUI

struct SpeedView: View {
  @Environment(\.measurementSystemInUse) private var measurementSystem

  let speed: Double
  let text: String
  let accessibilityText: String

  init(_ speed: Double) {
    self.speed = speed
    self.text = ""
    self.accessibilityText = ""
  }

  init(_ speed: Double, accessibilityText: String? = nil) {
    self.speed = speed
    self.text = ""
    self.accessibilityText = accessibilityText ?? text
  }

  init(_ text: String, _ speed: Double, accessibilityText: String? = nil) {
    self.speed = speed
    self.text = text + " "
    self.accessibilityText = accessibilityText ?? text
  }

  var body: some View {
    Text(text + speed.formatted(.speed(measurementSystem)))
      .accessibilityLabel(
        accessibilityText + speed.formatted(
          .speed(
            measurementSystem,
            width: .wide)))
  }
}
