//
// LocationManager.swift
// monoTENKI
//
// Created by Barreloofy on 6/20/25 at 6:17 PM
//

import CoreLocation

@MainActor
final class LocationServiceInterface: NSObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()

  var success: ((CLLocation) -> Void)?
  var failure: ((CLError) -> Void)?

  override init() {
    super.init()
    manager.delegate = self
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let success else { fatalError("No success handler assigned") }
    success(locations.last!)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    guard let failure else { fatalError("No failure handler assigned") }
    failure(error as! CLError)
  }
}


extension LocationServiceInterface {
  /// Register the Interface's callback handlers.
  /// - Parameters:
  ///   - success: The handler to call on success.
  ///   - failure: The handler to call on failure.
  func registerHandlers(
    success: @escaping (CLLocation) -> Void,
    failure: @escaping (any Error) -> Void) {
      self.success = success
      self.failure = failure
    }

  /// Requests the one-time delivery of the user’s current location.
  func requestLocation() {
    manager.requestLocation()
  }
}


extension CLLocationUpdate {
  /// Queries the current location from Core Location once.
  ///
  /// This method only gets the current location once,
  /// doesn’t start a location stream.
  ///
  /// - Throws: When location can't be determined.
  /// - Returns: The current location.
  @MainActor
  static func currentLocation() async throws -> CLLocation {
    let serviceInterface = LocationServiceInterface()

    return try await withCheckedThrowingContinuation { continuation in
      serviceInterface.registerHandlers { location in
        continuation.resume(returning: location)
      } failure: { error in
        continuation.resume(throwing: error)
      }
      serviceInterface.requestLocation()
    }
  }
}
