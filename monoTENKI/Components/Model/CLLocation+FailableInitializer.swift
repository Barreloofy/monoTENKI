//
//  CLLocation+FailableInitializer.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/13/25 at 3:45 PM.
//

import CoreLocation
// MARK: - Convenience failable initializer
extension CLLocation {
  convenience init?(from string: String) {
    guard let coordinate = CLLocationCoordinate2D.parseCoordinate(from: string) else { return nil }

    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}
