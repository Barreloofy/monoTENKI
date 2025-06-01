//
//  Double+PrecipitationFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/4/25 at 11:28 PM.
//

import Foundation

extension Double {
  /// Formats Double to a precipitation-unit.
  /// - Parameters:
  ///   - measurementSystem: The measurementSystem to use, Metric or Imperial.
  ///   - unitWidth: The width — such as full names or abbreviations — with which to present units.
  /// - Returns: The formatted precipitation-unit as a String.
  func precipitationFormatter(
    _ measurementSystem: MeasurementSystem,
    unitWidth: Measurement<UnitLength>.FormatStyle.UnitWidth = .abbreviated)
  -> String {
    guard self >= 0.1 else { return "0" }

    let value = Measurement<UnitLength>(value: self, unit: .millimeters)

    return value.converted(to: measurementSystem == .metric ? .millimeters : .inches)
      .formatted(.measurement(
        width: unitWidth,
        usage: .asProvided,
        numberFormatStyle: .number.rounded(rule: .toNearestOrAwayFromZero, increment: 0.1)))
  }
}
