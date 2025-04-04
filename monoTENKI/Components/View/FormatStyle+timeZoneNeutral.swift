//
//  FormatStyle+timeZoneNeutral.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/4/25 at 2:03 AM.
//

import Foundation
// MARK: - Format date time-zone neutral
extension FormatStyle where Self == Date.FormatStyle {
  static var timeZoneNeutral: Self {
    .Strategy(
      date: .omitted,
      time: .shortened,
      timeZone: TimeZone(abbreviation: "UTC")!)
  }
}
