//
// String+WindDirection.swift
// monoTENKI
//
// Created by Barreloofy on 6/1/25 at 9:47 PM
//

extension String {
  /// Converts a compass direction in it's abbreviated form to its wide form, able to convert 4, 8 and 16 point-compass's.
  /// - Returns: Returns the wide form of the input direction, if it matches one of the points, else returns self.
  func windDirectionWide() -> String {
    return switch self.lowercased() {
    case "n": "north"
    case "s": "south"
    case "e": "east"
    case "w": "west"
    case "ne": "northeast"
    case "se": "southeast"
    case "sw": "southwest"
    case "nw": "northwest"
    case "wnw": "west-northwest"
    case "nnw": "north-northwest"
    case "nne": "north-northeast"
    case "ene": "east-northeast"
    case "ese": "east-southeast"
    case "sse": "south-southeast"
    case "ssw": "south-southwest"
    case "wsw": "west-southwest"
    default: self
    }
  }
}
