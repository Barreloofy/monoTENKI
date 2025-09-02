//
// SpeedFormatTests.swift
// monoTENKI
//
// Created by Barreloofy on 9/2/25 at 12:44 PM
//

import Testing
@testable import monoTENKI

@Suite("SpeedFormat Tests")
struct SpeedFormatTests {
  @Test(
    "Validate metric formatting",
    arguments: [
      (-1000, "0"),
      (-10, "0"),
      (0, "0"),
      (10, "10 km/h"),
      (1000, "1,000 km/h"),
    ])
  func validateMetricFormatting(kph speed: Double, expected: String) async throws {
    // Arrange
    let formatter = SpeedFormat(measurementSystem: .metric, width: .abbreviated)

    // Act & Assert
    #expect(formatter.format(speed) == expected)
  }

  @Test(
    "Validate imperial formatting",
    arguments: [
      (-1000, "0"),
      (-10, "0"),
      (0, "0"),
      (10, "6 mph"),
      (1000, "621 mph"),
    ])
  func validateImperialFormatting(kph speed: Double, expected: String) async throws {
    // Arrange
    let formatter = SpeedFormat(measurementSystem: .imperial, width: .abbreviated)

    // Act & Assert
    #expect(formatter.format(speed) == expected)
  }

  @Test(
    "Validate incorrect precipitation input formatting",
    arguments: [
      (6, "10 km/h"),
      (621, "1000 km/h"),
    ])
  func validateIncorrectInput(mph speed: Double, expected: String) async throws {
    // Arrange
    let formatter = SpeedFormat(measurementSystem: .metric, width: .abbreviated)

    // Act & assert
    #expect(formatter.format(speed) != expected, "Base unit is kph, thus output and expected should not match")
  }

  @Test("Validate width option")
  func validateWidthOption() async throws {
    // Arrange
    let narrowFormatter = SpeedFormat(measurementSystem: .metric, width: .narrow)
    let abbreviatedFormatter = SpeedFormat(measurementSystem: .metric, width: .abbreviated)
    let wideFormatter = SpeedFormat(measurementSystem: .metric, width: .wide)

    let speed = 10.0

    // Act & assert
    #expect(narrowFormatter.format(speed) == "10km/h")

    #expect(abbreviatedFormatter.format(speed) == "10 km/h")

    #expect(wideFormatter.format(speed) == "10 kilometers per hour")
  }
}
