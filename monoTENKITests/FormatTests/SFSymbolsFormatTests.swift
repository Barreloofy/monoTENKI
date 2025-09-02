//
// SFSymbolsFormatTests.swift
// monoTENKI
//
// Created by Barreloofy on 9/1/25 at 1:24 PM
//

import Testing
@testable import monoTENKI

@Suite("SFSymbolsFormat Tests")
struct SFSymbolsFormatTests {
  @Test(
    "Validate day variant weather conditions",
    arguments: [
      ("sunny", "sun.max.fill"),
      ("clear", "sun.max.fill"),
      ("partly cloudy", "cloud.sun.fill"),
      ("cloudy", "cloud.fill"),
      ("overcast", "cloud.fill"),
      ("fog", "cloud.fog.fill"),
      ("mist", "cloud.fog.fill"),
      ("rain", "cloud.rain.fill"),
      ("drizzle", "cloud.rain.fill"),
      ("snow", "cloud.snow.fill"),
      ("sleet", "cloud.sleet.fill"),
      ("freezing", "snowflake"),
      ("thunder", "cloud.bolt.rain.fill"),
      ("blizzard", "wind.snow"),
      ("blowing snow", "wind.snow"),
    ])
  func validateDayWeatherCondition(condition: String, expected: String) {
    // Arrange
    let formatter = SFSymbolsFormat(isDay: true)

    // Act & Assert
    #expect(formatter.format(condition) == expected)
  }

  @Test(
    "Validate night variant weather conditions",
    arguments: [
      ("sunny", "moon.fill"),
      ("clear", "moon.fill"),
      ("partly cloudy", "cloud.moon.fill"),
      ("cloudy", "cloud.fill"),
      ("overcast", "cloud.fill"),
      ("fog", "cloud.fog.fill"),
      ("mist", "cloud.fog.fill"),
      ("rain", "cloud.rain.fill"),
      ("drizzle", "cloud.rain.fill"),
      ("snow", "cloud.snow.fill"),
      ("sleet", "cloud.sleet.fill"),
      ("freezing", "snowflake"),
      ("thunder", "cloud.bolt.rain.fill"),
      ("blizzard", "wind.snow"),
      ("blowing snow", "wind.snow"),
    ])
  func validateNightWeatherCondition(condition: String, expected: String) async throws {
    // Arrange
    let formatter = SFSymbolsFormat(isDay: false)

    // Act & Assert
    #expect(formatter.format(condition) == expected)
  }

  @Test(
    "Validate edge cases",
    arguments: [
      ("", "cloud.fill"),
      ("   ", "cloud.fill"),
      ("invalid condition", "cloud.fill"),
      ("PARTLY CLOUDY ", "cloud.sun.fill"),
      ("  light rain  ", "cloud.rain.fill"),
    ])
  func validateEdgeCases(input: String, expected: String) async throws {
    // Arrange
    let formatter = SFSymbolsFormat(isDay: true)

    // Act & Assert
    #expect(formatter.format(input) == expected)
  }
}
