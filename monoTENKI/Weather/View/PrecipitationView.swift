//
// PrecipitationView.swift
// monoTENKI
//
// Created by Barreloofy on 6/1/25 at 2:27 PM
//

import SwiftUI

struct PrecipitationView: View {
  @Environment(\.measurementSystem) private var measurementSystem

  let precipitation: Double
  let text: String
  let accessibilityText: String

  init(_ precipitation: Double) {
    self.precipitation = precipitation
    self.text = ""
    self.accessibilityText = ""
  }

  init(_ precipitation: Double, accessibilityText: String? = nil) {
    self.precipitation = precipitation
    self.text = ""
    self.accessibilityText = accessibilityText ?? text
  }

  init(_ text: String, _ precipitation: Double, accessibilityText: String? = nil) {
    self.precipitation = precipitation
    self.text = text + " "
    self.accessibilityText = accessibilityText ?? text
  }

  var body: some View {
    Text(text + precipitation.formatted(.precipitation(measurementSystem)))
      .accessibilityLabel(
        accessibilityText + precipitation.formatted(
          .precipitation(
            measurementSystem,
            width: .wide)))
  }
}
