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
class LocationAggregate {
  private var locationStorage = UserDefault(key: "location", defaultValue: "")
  var location: String {
    get { locationStorage.value }
    set { locationStorage.value = newValue }
  }
  private var trackLocationStorage = UserDefault(key: "trackLocation", defaultValue: false)
  var trackLocation: Bool {
    get { trackLocationStorage.value }
    set {
      trackLocationStorage.value = newValue
      updateTrackLocation()
    }
  }

  private var locationStream: Task<Void, Error>?

  init() { updateTrackLocation() }

  func resume() {
    guard trackLocation && locationStream == nil else { return }
    startLocationTracking()
  }

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
      var previousLocation = CLLocation(from: location)

      let distanceThresholdMeters = 250.0
      let filterByDistance: @MainActor (CLLocationUpdate) -> Bool = { update in
        guard let location = update.location else { return false }

        guard let unwrappedPreviousLocation = previousLocation else {
          previousLocation = location
          return true
        }

        if location.distance(from: unwrappedPreviousLocation) > distanceThresholdMeters {
          previousLocation = location
          return true
        } else {
          return false
        }
      }

      for try await update in CLLocationUpdate.liveUpdates().filter({ await filterByDistance($0) }) {
        guard let newLocation = update.location?.coordinate.stringRepresentation else { continue }

        location = newLocation
      }
    }
  }
}
