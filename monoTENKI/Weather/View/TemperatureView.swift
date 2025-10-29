//
// TemperatureView.swift
// monoTENKI
//
// Created by Barreloofy on 6/1/25 at 12:47 PM
//

import SwiftUI

struct TemperatureView: View {
  @Environment(\.measurementSystemInUse) private var measurementSystem

  let temperature: Double
  let text: String
  let accessibilityText: String

  init(_ temperature: Double) {
    self.temperature = temperature
    self.text = ""
    self.accessibilityText = ""
  }

  init(_ temperature: Double, accessibilityText: String? = nil) {
    self.temperature = temperature
    self.text = ""
    self.accessibilityText = accessibilityText ?? text
  }

  init(_ text: String, _ temperature: Double, accessibilityText: String? = nil) {
    self.temperature = temperature
    self.text = text + " "
    self.accessibilityText = accessibilityText ?? text
  }

  var body: some View {
    Text(text + temperature.formatted(.temperature(measurementSystem)))
      .accessibilityLabel(
        accessibilityText + temperature.formatted(
          .temperature(
            measurementSystem,
            width: .wide,
            hideScaleName: false)))
  }
}
