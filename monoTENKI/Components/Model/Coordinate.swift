//
//  Coordinate.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/13/25 at 3:48 PM.
//

import CoreLocation

nonisolated
struct Coordinate: Equatable, Codable, CustomStringConvertible {
  var latitude: Double
  var longitude: Double

  var description: String {
    "\(latitude), \(longitude)"
  }
}


extension Coordinate {
  /// Creates a new instance of `Coordinate` with `latitude` and `longitude` set to `0`.
  nonisolated
  init() {
    self.init(
      latitude: .zero,
      longitude: .zero)
  }
}


extension CLLocation {
  /// Creates a new instance of `Coordinate` from the `latitude` and `longitude` values of the `coordinate` property.
  /// - Returns: A instance of `Coordinate`.
  func makeCoordinate() -> Coordinate {
    Coordinate(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude)
  }
}
