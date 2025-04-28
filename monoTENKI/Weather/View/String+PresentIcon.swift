//
//  String+PresentIcon.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 4:01 PM.
//

// MARK: - Returns the correct 'SF Symbols' icon name
extension String {
  /// Day-night aware function to retrieve the correct 'SF Symbols' icon name for the given condition
  func presentIcon(isDay: Bool) -> String {
    let condition = self.trimmingCharacters(in: .whitespaces).lowercased()

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
    case let condition where condition.contains(snow):
      return "cloud.snow.fill"
    case let condition where condition.contains(sleet):
      return "cloud.sleet.fill"
    case let condition where condition.contains(freezing):
      return "cloud.hail.fill"
    case let condition where condition.contains(thunder):
      return "cloud.bolt.rain.fill"
    case let condition where condition.contains(blizzard):
      return "wind.snow"
    default:
      return "cloud.fill"
    }
  }
}
