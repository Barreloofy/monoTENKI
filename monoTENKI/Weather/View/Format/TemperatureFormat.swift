//
//  TemperatureFormat.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/22/25 at 1:33 PM.
//

import Foundation

struct TemperatureFormat: FormatStyle {
  let measurementSystem: MeasurementSystem
  let width: Measurement<UnitTemperature>.FormatStyle.UnitWidth
  let hideScaleName: Bool

  func format(_ value: Double) -> String {
    var temperature: Measurement<UnitTemperature> = .init(value: value, unit: .celsius)

    if (-0.4...0).contains(temperature.value) { temperature.value = 0 }
    if measurementSystem == .imperial { temperature.convert(to: .fahrenheit) }

    return temperature.formatted(
      .measurement(
        width: width,
        usage: .asProvided,
        hidesScaleName: hideScaleName,
        numberFormatStyle: .number.rounded(
          rule: .toNearestOrAwayFromZero,
          increment: 1)))
  }
}


extension FormatStyle where Self == TemperatureFormat {
  /// Formats Double to temperature unit.
  ///
  /// > Important: `TemperatureFormat` base unit is `celsius`.
  /// - Parameters:
  ///   - measurementSystem: The measurementSystem to use.
  ///   - width: The width — such as full names or abbreviations — with which to present units.
  ///   - hideScaleName: To hide the units scale-name, such as, degrees Celsius, or degrees Fahrenheit.
  /// - Returns: The formatted temperature as an instance of `TemperatureFormat`.
  static func temperature(
    _ measurementSystem: MeasurementSystem,
    width: Measurement<UnitTemperature>.FormatStyle.UnitWidth = .abbreviated,
    hideScaleName: Bool = true)
  -> TemperatureFormat {
    .init(measurementSystem: measurementSystem, width: width, hideScaleName: hideScaleName)
  }
}
