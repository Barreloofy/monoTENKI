//
//  LocationAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 8:11 PM.
//

import Foundation
import CoreLocation

/// Location aggregate model.
@MainActor
@Observable
final class LocationAggregate {
  private var locationStorage = UserDefault(key: .location, defaultValue: CLLocationCoordinate2D())
  var location: CLLocationCoordinate2D {
    get { locationStorage() }
    set { locationStorage(newValue) }
  }

  private var trackLocationStorage = UserDefault(key: .trackLocation, defaultValue: false)
  var trackLocation: Bool {
    get { trackLocationStorage() }
    set {
      trackLocationStorage(newValue)
      updateTrackLocation()
    }
  }

  private var locationStream: Task<Void, any Error>?

  init() { updateTrackLocation() }

  /// Enable location tracking.
  func startTracking() {
    trackLocation = true
  }

  /// Stop location tracking and optionally set a new location.
  func stopTracking(_ newLocation: CLLocationCoordinate2D? = nil) {
    defer { trackLocation = false }
    guard let newLocation else { return }
    location = newLocation
  }

  /// Resumes location tracking if active, but was previously suspended.
  func resume() {
    guard trackLocation && locationStream == nil else { return }
    startLocationTracking()
  }

  /// Pauses location tracking if active.
  func suspend() {
    guard trackLocation && locationStream != nil else { return }
    locationStream?.cancel()
    locationStream = nil
  }

  private func updateTrackLocation() {
    if trackLocation {
      guard locationStream == nil else { return }
      startLocationTracking()
    } else {
      locationStream?.cancel()
      locationStream = nil
    }
  }

  private func startLocationTracking() {
    locationStream = Task {
      var previousLocation = CLLocation.init(
        latitude: location.latitude,
        longitude: location.longitude)

      let distanceThresholdInMeters = 250.0

      let filterByDistance: @UpdateProcessor (CLLocation) -> Bool = { location in
        if location.distance(from: previousLocation) > distanceThresholdInMeters {
          previousLocation = location
          return true
        } else {
          return false
        }
      }

      for try await update in CLLocationUpdate.liveUpdates()
        .compactMap(\.location)
        .filter(filterByDistance)
      {
        location = update.coordinate
      }
    }
  }
}
