//
//  PrecipitationFormat.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/4/25 at 11:28 PM.
//

import Foundation

struct PrecipitationFormat: FormatStyle {
  let measurementSystem: MeasurementSystem
  let width: Measurement<UnitLength>.FormatStyle.UnitWidth

  private func metricFormat(_ precipitationMillimeter: Measurement<UnitLength>) -> String {
    guard precipitationMillimeter.value >= 1 else { return "0" }

    return precipitationMillimeter.formatted(
      .measurement(
        width: width,
        usage: .asProvided,
        numberFormatStyle: .number.rounded(
          rule: .toNearestOrAwayFromZero,
          increment: 1)))
  }

  private func imperialFormat(_ precipitationMillimeter: Measurement<UnitLength>) -> String {
    guard precipitationMillimeter.value >= 0.254 else { return "0" }

    return precipitationMillimeter.converted(to: .inches).formatted(
      .measurement(
        width: width,
        usage: .asProvided,
        numberFormatStyle: .number.rounded(
          rule: .toNearestOrAwayFromZero,
          increment: 0.01)))
  }


  func format(_ value: Double) -> String {
    let precipitation: Measurement<UnitLength> = .init(value: value, unit: .millimeters)

    return switch measurementSystem {
    case .metric: metricFormat(precipitation)
    case .imperial: imperialFormat(precipitation)
    }
  }
}


extension FormatStyle where Self == PrecipitationFormat {
  /// Formats Double to precipitation unit.
  ///
  /// > Important: `PrecipitationFormat` base unit is `millimeters`.
  /// - Parameters:
  ///   - measurementSystem: The measurementSystem to use.
  ///   - width: The width — such as full names or abbreviations — with which to present units.
  /// - Returns: The formatted precipitation value as an instance of `PrecipitationFormat`.
  static func precipitation(
    _ measurementSystem: MeasurementSystem,
    width: Measurement<UnitLength>.FormatStyle.UnitWidth = .abbreviated)
  -> PrecipitationFormat {
    .init(measurementSystem: measurementSystem, width: width)
  }
}
