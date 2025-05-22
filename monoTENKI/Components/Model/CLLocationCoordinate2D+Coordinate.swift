//
//  CLLocationCoordinate2D+Coordinate.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/13/25 at 3:48 PM.
//

import CoreLocation
// Convert String to CLLocationCoordinate2D
extension CLLocationCoordinate2D {
  static func parseCoordinate(from string: String) -> CLLocationCoordinate2D? {
    let cleaned = string.replacingOccurrences(of: ",", with: "")
    let components = cleaned.components(separatedBy: .whitespaces).compactMap { Double($0) }

    guard components.count == 2 else { return nil }

    return CLLocationCoordinate2DMake(components[0], components[1])
  }
}

// Convenience property
extension CLLocationCoordinate2D {
  var stringRepresentation: String {
    "\(latitude), \(longitude)"
  }
}
