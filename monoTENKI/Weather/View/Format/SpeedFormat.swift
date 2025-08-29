//
//  SpeedFormat.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/5/25 at 11:59 PM.
//

import Foundation

struct SpeedFormat: FormatStyle {
  let measurementSystem: MeasurementSystem
  let width: Measurement<UnitSpeed>.FormatStyle.UnitWidth

  func format(_ value: Double) -> String {
    var speed: Measurement<UnitSpeed> = .init(value: value, unit: .kilometersPerHour)

    if measurementSystem == .imperial { speed.convert(to: .milesPerHour) }

    return speed.formatted(
      .measurement(
        width: width,
        usage: .asProvided,
        numberFormatStyle: .number.rounded(
          rule: .toNearestOrAwayFromZero,
          increment: 1)))
  }
}


extension FormatStyle where Self == SpeedFormat {
  /// Formats Double to speed unit.
  /// - Parameters:
  ///   - measurementSystem: The measurementSystem to use.
  ///   - width: The width — such as full names or abbreviations — with which to present units.
  /// - Returns: The formatted speed value as an instance of `SpeedFormat`.
  static func speed(
    _ measurementSystem: MeasurementSystem,
    width: Measurement<UnitSpeed>.FormatStyle.UnitWidth = .abbreviated)
  -> SpeedFormat {
    .init(measurementSystem: measurementSystem, width: width)
  }
}
