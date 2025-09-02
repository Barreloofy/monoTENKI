//
// PrecipitationFormatTests.swift
// monoTENKI
//
// Created by Barreloofy on 9/2/25 at 11:38 AM
//

import Testing
@testable import monoTENKI

@Suite("PrecipitationFormat Tests")
struct PrecipitationFormatTests {
  @Test(
    "Validate metric formatting",
    arguments: [
      (-1, "0"),
      (0, "0"),
      (0.5, "0"),
      (1, "1 mm"),
      (10, "10 mm"),
      (25.4, "25 mm")
    ])
  func validateMetricFormatting(millimeters precipitation: Double, expected: String) async throws {
    // Arrange
    let formatter = PrecipitationFormat(measurementSystem: .metric, width: .abbreviated)

    // Act & Assert
    #expect(formatter.format(precipitation) == expected)
  }

  @Test(
    "Validate imperial formatting",
    arguments: [
      (-1, "0"),
      (0, "0"),
      (0.5, "0.02 in"),
      (1, "0.04 in"),
      (10, "0.39 in"),
      (25.4, "1.00 in"),
    ])
  func validateImperialFormatting(millimeters precipitation: Double, expected: String) async throws {
    // Arrange
    let formatter = PrecipitationFormat(measurementSystem: .imperial, width: .abbreviated)

    // Act & Assert
    #expect(formatter.format(precipitation) == expected)
  }

  @Test(
    "Validate incorrect precipitation input formatting",
    arguments: [
      (0, "-1 mm"),
      (0.02, "0.5 mm"),
      (0.04, "1 mm"),
      (0.39, "10 mm"),
      (1, "25 mm"),
    ])
  func validateWrongInput(inch precipitation: Double, expected: String) async throws {
    // Arrange
    let formatter = PrecipitationFormat(measurementSystem: .metric, width: .abbreviated)

    // Act & Assert
    #expect(formatter.format(precipitation) != expected, "Base unit is millimeters, thus output and expected should not match")
  }

  @Test("Validate width option")
  func validateWidthOption() async throws {
    // Arrange
    let narrowFormatter = PrecipitationFormat(measurementSystem: .metric, width: .narrow)
    let abbreviatedFormatter = PrecipitationFormat(measurementSystem: .metric, width: .abbreviated)
    let wideFormatter = PrecipitationFormat(measurementSystem: .metric, width: .wide)

    let precipitation = 1.0

    // Act & Assert
    #expect(narrowFormatter.format(precipitation) == "1mm")

    #expect(abbreviatedFormatter.format(precipitation) == "1 mm")

    #expect(wideFormatter.format(precipitation) == "1 millimeter")
  }
}
