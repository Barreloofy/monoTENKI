//
//  CLLocationCoordinate2D+Coordinate.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/13/25 at 3:48 PM.
//

import CoreLocation

extension CLLocationCoordinate2D {
  static func parseCoordinate(from string: String) -> CLLocationCoordinate2D? {
    let components = string.split { $0 == "," || $0 == " " }.compactMap { Double($0) }

    guard components.count == 2 else { return nil }

    return CLLocationCoordinate2DMake(components[0], components[1])
  }
}


extension CLLocationCoordinate2D {
  var stringRepresentation: String {
    "\(latitude), \(longitude)"
  }
}
