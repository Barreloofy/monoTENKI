//
// TemperatureFormatTests.swift
// monoTENKI
//
// Created by Barreloofy on 9/1/25 at 4:34 PM
//

import Testing
@testable import monoTENKI

@Suite("TemperatureFormat Tests")
struct TemperatureFormatTests {
  @Test(
    "Validate metric formatting. TemperatureFormat expects a celsius value as its base value",
    arguments: [
      (-1000, "-1,000°"),
      (-10.0, "-10°"),
      (-0.2, "0°"),
      (0, "0°"),
      (10, "10°"),
      (1000, "1,000°"),
    ])
  func validateMetricFormatting(celsius temperature: Double, expected: String) async throws {
    // Arrange
    let formatter = TemperatureFormat(measurementSystem: .metric, width: .abbreviated, hideScaleName: true)

    // Act & Assert
    #expect(formatter.format(temperature) == expected)
  }

  @Test(
    "Validate imperial formatting. TemperatureFormat expects a celsius value as its base value",
    arguments: [
      (-1000, "-1,768°"),
      (-10.0, "14°"),
      (-0.2, "32°"),
      (0, "32°"),
      (10, "50°"),
      (1000, "1,832°"),
    ])
  func validateImperialFormatting(celsius temperature: Double, expected: String) async throws {
    // Arrange
    let formatter = TemperatureFormat(measurementSystem: .imperial, width: .abbreviated, hideScaleName: true)

    // Act && Assert
    #expect(formatter.format(temperature) == expected)
  }

  @Test(
    "Validate that wrong input behaves expected. TemperatureFormat expects a celsius value as its base value",
    arguments: [
      (1768, "-1,000°"),
      (14, "-10°"),
      (32, "0°"),
      (50, "10°"),
      (1832, "1,000°"),
    ])
  func validateWrongInput(fahrenheit temperature: Double, expected: String) async throws {
    let formatter = TemperatureFormat(measurementSystem: .metric, width: .abbreviated, hideScaleName: true)

    #expect(formatter.format(temperature) != expected)
  }

  @Test("Validate width option")
  func validateWidth() async throws {
    let narrowFormatter = TemperatureFormat(measurementSystem: .metric, width: .narrow, hideScaleName: true)
    let abbreviatedFormatter = TemperatureFormat(measurementSystem: .metric, width: .abbreviated, hideScaleName: true)
    let wideFormatter = TemperatureFormat(measurementSystem: .metric, width: .wide, hideScaleName: true)

    let temperature = 20.0

    #expect(abbreviatedFormatter.format(temperature) == "20°")

    #expect(narrowFormatter.format(temperature) == "20°")

    #expect(wideFormatter.format(temperature) == "20 degrees")
  }

  @Test("Validate hideScaleName option")
  func validateHideScaleName() async throws {
    let hidden = TemperatureFormat(measurementSystem: .metric, width: .wide, hideScaleName: true)
    let visible = TemperatureFormat(measurementSystem: .metric, width: .wide, hideScaleName: false)

    let temperature = 20.0

    #expect(hidden.format(temperature) == "20 degrees")

    #expect(visible.format(temperature) == "20 degrees Celsius")
  }
}
