//
//  Double+LengthFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/4/25 at 11:28 PM.
//

import Foundation

extension Double {
  func LengthFormatter(_ measurementSystem: MeasurementSystem) -> String {
    let length = Measurement<UnitLength>(value: self, unit: .centimeters)
    return length.formatted(createLengthStyle(measurementSystem))
  }
}

private typealias LengthFormatterStyle = Measurement<UnitLength>.FormatStyle
private func createLengthStyle(_ measurementSystem: MeasurementSystem) -> LengthFormatterStyle {
  return LengthFormatterStyle(
    width: .narrow,
    locale: measurementSystem == .metric ? Locale(identifier: "fr_FR") : Locale(identifier: "en_US"),
    usage: .snowfall,
    hidesScaleName: true,
    numberFormatStyle: .number.precision(.fractionLength(1)))
}
