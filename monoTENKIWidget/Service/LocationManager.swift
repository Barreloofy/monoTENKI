//
// LocationManager.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:17 PM
//

import AsyncAlgorithms
import CoreLocation

@MainActor
final class LocationManager: NSObject, @preconcurrency CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private let channel = AsyncChannel<CLLocation?>()

  override init() {
    super.init()
    manager.delegate = self
  }

  func requestLocation() async throws -> CLLocation {
    manager.requestLocation()

    for await value in channel {
      guard let value = value else { throw CLError(.locationUnknown) }
      return value
    }

    throw CLError(.locationUnknown)
  }

  // Static access method
  static func requestLocation() async throws -> CLLocation {
    let locationManager = LocationManager()
    return try await locationManager.requestLocation()
  }

  // Delegate methods
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    Task { await channel.send(locations.last) }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    Task { await channel.send(nil) }
  }
}
