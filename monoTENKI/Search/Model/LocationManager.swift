//
//  LocationManager.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/23/25 at 3:17 PM.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
  var location: CLLocation?
  var error = false

  private let locationManager = CLLocationManager()

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.distanceFilter = 1_000
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
}

// MARK: - CLLocationManagerDelegate method implementation
extension LocationManager {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let newLocation = locations.first else { return }
    location = newLocation
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    self.error = true
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let authorizationStatus = manager.authorizationStatus

    switch authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.startUpdatingLocation()
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    default:
      manager.startUpdatingLocation()
    }
  }
}
