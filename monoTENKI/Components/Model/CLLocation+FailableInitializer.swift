//
//  CLLocation+FailableInitializer.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/13/25 at 3:45 PM.
//

import CoreLocation
// Convenience failable initializer
extension CLLocation {
  /// Parameter 'string' should be a comma-separated coordinate with or without a whitespace, i.e, (lat, lon), (lat,lon)
  convenience init?(from string: String) {
    guard let coordinate = CLLocationCoordinate2D.parseCoordinate(from: string) else { return nil }

    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}
