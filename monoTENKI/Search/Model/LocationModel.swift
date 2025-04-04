//
//  LocationModel.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 8:11 PM.
//

import Foundation
import CoreLocation
/// Location aggregate model
@MainActor
@Observable
class LocationModel {
  var location = "" { didSet { UserDefaults.standard.set(location, forKey: "location") } }
  var trackLocation = false { didSet { trackLocationUpdate() } }

  private var locationStream: Task<Void, Error>?

  init() {
    location = UserDefaults.standard.string(forKey: "location") ?? ""
    trackLocation = UserDefaults.standard.bool(forKey: "trackLocation")
  }

  private func trackLocationUpdate() {
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
      var previousLocation: CLLocation?
      let filterByDistance: (CLLocationUpdate) -> Bool = { update in
        guard let location = update.location else { return false }

        guard let unwrappedPreviousLocation = previousLocation else {
          previousLocation = update.location
          return true
        }

        if location.distance(from: unwrappedPreviousLocation) > 100 {
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

// MARK: - Convenience property
extension CLLocationCoordinate2D {
  var stringRepresentation: String {
    "\(latitude) \(longitude)"
  }
}
