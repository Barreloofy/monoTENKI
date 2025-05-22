//
//  Double+SpeedFormatter.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/5/25 at 11:59 PM.
//

import Foundation
// Format length to locale-aware speed representation
extension Double {
  func SpeedFormatter(_ measurementSystem: MeasurementSystem) -> String {
    let speed = Measurement<UnitSpeed>(value: self, unit: .kilometersPerHour)

    return speed.converted(to: measurementSystem == .metric ? .kilometersPerHour : .milesPerHour)
      .formatted(.measurement(
        width: .abbreviated,
        usage: .asProvided,
        numberFormatStyle: .number.rounded(rule: .toNearestOrAwayFromZero, increment: 1)))
  }
}
