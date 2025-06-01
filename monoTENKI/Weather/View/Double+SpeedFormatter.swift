//
//  Double+SpeedFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/5/25 at 11:59 PM.
//

import Foundation

extension Double {
  /// Formats Double to a speed-unit.
  /// - Parameters:
  ///   - measurementSystem: The measurementSystem to use, Metric or Imperial.
  ///   - unitWidth: The width — such as full names or abbreviations — with which to present units.
  /// - Returns: The formatted speed-unit as a String.
  func SpeedFormatter(
    _ measurementSystem: MeasurementSystem,
    unitWidth: Measurement<UnitSpeed>.FormatStyle.UnitWidth = .abbreviated)
  -> String {
    let speed = Measurement<UnitSpeed>(value: self, unit: .kilometersPerHour)

    return speed.converted(to: measurementSystem == .metric ? .kilometersPerHour : .milesPerHour)
      .formatted(.measurement(
        width: unitWidth,
        usage: .asProvided,
        numberFormatStyle: .number.rounded(rule: .toNearestOrAwayFromZero, increment: 1)))
  }
}
