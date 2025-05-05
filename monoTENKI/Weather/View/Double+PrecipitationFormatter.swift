//
//  Double+PrecipitationFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/4/25 at 11:28 PM.
//

import Foundation
// MARK: - Format length to locale-aware precipitation representation
extension Double {
  func precipitationFormatter(_ measurementSystem: MeasurementSystem) -> String {
    guard self > 0 else { return "0" }

    let value = Measurement<UnitLength>(value: self, unit: .millimeters)

    return value.converted(to: measurementSystem == .metric ? .millimeters : .inches)
      .formatted(.measurement(
        width: .abbreviated,
        usage: .asProvided,
        numberFormatStyle: .number.rounded(rule: .up, increment: 0.01)))
  }
}
