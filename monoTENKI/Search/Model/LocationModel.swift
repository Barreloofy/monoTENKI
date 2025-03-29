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
  var location = ""
  var trackLocation = false { didSet { trackLocationUpdate() } }

  private var locationLoop: Task<Void, Error>?

  init() {
    trackLocation = UserDefaults.standard.bool(forKey: "trackLocation")
  }

  private func trackLocationUpdate() {
    if trackLocation {
      startLocationTracking()
    } else {
      locationLoop?.cancel()
      locationLoop = nil
    }

    UserDefaults.standard.set(trackLocation, forKey: "trackLocation")
  }

  private func startLocationTracking() {
    guard locationLoop == nil else { return }

    locationLoop = Task {
      for try await update in CLLocationUpdate.liveUpdates() {
        guard let newLocation = update.location else { continue }

        location = newLocation.coordinate.stringRepresentation
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
