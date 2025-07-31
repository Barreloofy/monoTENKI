//
//  FormatStyle+shortenedAndTimeZoneNeutral.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/4/25 at 2:03 AM.
//

import Foundation

extension FormatStyle where Self == Date.FormatStyle {
  static var shortenedAndTimeZoneNeutral: Self {
    .Strategy(
      date: .omitted,
      time: .shortened,
      timeZone: TimeZone(abbreviation: "UTC")!)
  }
}
