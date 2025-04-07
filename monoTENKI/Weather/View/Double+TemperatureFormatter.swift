//
//  Double+TemperatureFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/22/25 at 1:33 PM.
//

import Foundation
// MARK: - Format Double to locale-aware temperature representation
extension Double {
  /// Locale-aware temperature formatter that takes in a 'MeasurementSystem' type usually retrieved from the environment
  func temperatureFormatter(_ measurementSystem: MeasurementSystem) -> String {
    let temperature = Measurement<UnitTemperature>(value: self, unit: .celsius)
    return temperature.converted(to: measurementSystem == .metric ? .celsius : .fahrenheit)
      .formatted(.measurement(
        width: .abbreviated,
        usage: .asProvided,
        hidesScaleName: true,
        numberFormatStyle: .number.precision(.fractionLength(.zero))))
  }
}
