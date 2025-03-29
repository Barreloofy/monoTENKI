//
//  Double+TemperatureFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/22/25 at 1:33 PM.
//

import Foundation
// MARK: - Format Double to locale-aware temperature representation
extension Double {
  func temperatureFormatter(_ measurementSystem: MeasurementSystem) -> String {
    let temperature = Measurement<UnitTemperature>(value: self, unit: .celsius)
    return temperature.formatted(createTemperatureStyle(measurementSystem))
  }
}

private typealias TemperatureFormatStyle = Measurement<UnitTemperature>.FormatStyle
private func createTemperatureStyle(_ measurementSystem: MeasurementSystem) -> TemperatureFormatStyle {
  return Measurement<UnitTemperature>.FormatStyle(
    width: .abbreviated,
    locale: measurementSystem == .metric ? Locale(identifier: "fr_FR") : Locale(identifier: "en_US"),
    usage: .weather,
    hidesScaleName: false,
    numberFormatStyle: .number.precision(.fractionLength(0)))
}
