//
//  Double+TemperatureFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/22/25 at 1:33 PM.
//

import Foundation

extension Double {
  /// Formats Double to a temperature.
  /// - Parameters:
  ///   - measurementSystem: The measurementSystem to use, Metric or Imperial.
  ///   - unitWidth: The width — such as full names or abbreviations — with which to present units.
  ///   - hideScaleName: To hide the units scale-name, such as, degrees Celsius, or degrees Fahrenheit.
  /// - Returns: The formatted temperature as a String.
  func temperatureFormatter(
    _ measurementSystem: MeasurementSystem,
    unitWidth: Measurement<UnitTemperature>.FormatStyle.UnitWidth = .abbreviated,
    hideScaleName: Bool = true)
  -> String {
    var input = self

    if (-0.4...0).contains(input) { input = 0 }

    let temperature = Measurement<UnitTemperature>(value: input, unit: .celsius)
    return temperature.converted(to: measurementSystem == .metric ? .celsius : .fahrenheit)
      .formatted(.measurement(
        width: unitWidth,
        usage: .asProvided,
        hidesScaleName: hideScaleName,
        numberFormatStyle: .number.rounded(rule: .toNearestOrAwayFromZero, increment: 1)))
  }
}
