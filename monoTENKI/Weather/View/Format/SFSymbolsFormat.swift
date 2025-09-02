//
//  String+PresentIcon.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 4:01 PM.
//

import Foundation

struct SFSymbolsFormat: FormatStyle {
  let isDay: Bool

  func format(_ value: String) -> String {
    let condition = value.trimmingCharacters(in: .whitespaces).lowercased()

    let sunnyClear = /(sunny|clear)/
    let partlyCloudy = /partly cloudy/
    let cloudy = /(cloudy|overcast)/
    let fogMist = /(fog|mist)/
    let rainDrizzle = /(rain|drizzle)/
    let snow = /snow/
    let sleet = /sleet/
    let freezing = /freezing/
    let thunder = /thunder/
    let blizzard = /(blizzard|blowing snow)/

    switch condition {
    case let condition where condition.contains(sunnyClear):
      return isDay ? "sun.max.fill" : "moon.fill"
    case let condition where condition.contains(partlyCloudy):
      return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
    case let condition where condition.contains(cloudy):
      return "cloud.fill"
    case let condition where condition.contains(fogMist):
      return "cloud.fog.fill"
    case let condition where condition.contains(rainDrizzle):
      return "cloud.rain.fill"
    case let condition where condition.contains(snow) && !condition.contains("blowing snow"):
      return "cloud.snow.fill"
    case let condition where condition.contains(sleet):
      return "cloud.sleet.fill"
    case let condition where condition.contains(freezing):
      return "snowflake"
    case let condition where condition.contains(thunder):
      return "cloud.bolt.rain.fill"
    case let condition where condition.contains(blizzard):
      return "wind.snow"
    default:
      return "cloud.fill"
    }
  }
}


extension FormatStyle where Self == SFSymbolsFormat {
  /// Converts condition into its `SF Symbols` representation.
  /// - Parameter isDay: Whether to use the day or night variant.
  /// - Returns: The formatted condition as an instance of `SFSymbolsFormat`.
  static func sfSymbols(isDay: Bool) -> SFSymbolsFormat {
    .init(isDay: isDay)
  }
}
