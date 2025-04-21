//
//  LocationAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 8:11 PM.
//

import Foundation
import CoreLocation
/// Location aggregate model
@MainActor
@Observable
class LocationAggregate {
  var location = UserDefaults.standard.string(forKey: "location") ?? "" {
    didSet { UserDefaults.standard.set(location, forKey: "location") }
  }
  var trackLocation = UserDefaults.standard.bool(forKey: "trackLocation") {
    didSet { updateTrackLocation() }
  }

  private var locationStream: Task<Void, Error>?

  init() { updateTrackLocation() }

  private func updateTrackLocation() {
    if trackLocation {
      startLocationTracking()
    } else {
      locationStream?.cancel()
      locationStream = nil
    }

    UserDefaults.standard.set(trackLocation, forKey: "trackLocation")
  }

  private func startLocationTracking() {
    guard locationStream == nil else { return }

    locationStream = Task {
      var previousLocation = CLLocation.init(from: location)

      let distanceThresholdMeters = 250.0
      let filterByDistance: (CLLocationUpdate) -> Bool = { update in
        guard let location = update.location else { return false }

        guard let unwrappedPreviousLocation = previousLocation else {
          previousLocation = update.location
          return true
        }

        if location.distance(from: unwrappedPreviousLocation) > distanceThresholdMeters {
          previousLocation = location
          return true
        } else {
          return false
        }
      }

      for try await update in CLLocationUpdate.liveUpdates().filter({ @MainActor in filterByDistance($0) }) {
        guard let newLocation = update.location?.coordinate.stringRepresentation else { continue }

        location = newLocation
      }
    }
  }
}
