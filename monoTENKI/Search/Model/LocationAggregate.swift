//
//  LocationAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 8:11 PM.
//

import CoreLocation

/// An aggregate that manages locaion as a finite state machine.
///
/// The aggregate is in either state:
///   - manual, update aggregate directly.
///   - automatic, the aggregate continuously updates itself.
@MainActor
@Observable
final class LocationAggregate {
  enum State: Codable {
    case manual, automatic
  }

  enum Event {
    case automate, manualize, suspend, resume, set(Coordinate)
  }

  private var stream: Task<Void, any Error>?

  private var state: State {
    get {
      UserDefaults.standard.codableType(
        for: .locationAggregateState,
        defaultValue: .manual)
    }
    set {
      UserDefaults.standard.set(
        newValue,
        for: .locationAggregateState)
    }
  }

  private(set) var location: Coordinate {
    get {
      access(keyPath: \.location)
      return UserDefaults.standard.codableType(
        for: .location,
        defaultValue: Coordinate())
    }
    set {
      withMutation(keyPath: \.location) {
        UserDefaults.standard.set(
          newValue,
          for: .location)
      }
    }
  }

  init() {
    process(event: .resume)
  }
  
  /// Process event requests and respond with possible state transition.
  /// - Parameter event: The event to respond to.
  private func process(event: Event) {
    switch state {
    case .manual:
      switch event {
      case .automate:
        state = .automatic
        stream = startLocationStream()
      case let .set(newLocation):
        location = newLocation
      default: return
      }
    case .automatic:
      switch event {
      case .manualize:
        state = .manual
        stream?.cancel()
      case .suspend:
        stream?.cancel()
      case .resume:
        stream = stream?.isCancelled == true ? startLocationStream() : nil
      default: return
      }
    }
  }
  
  /// Begins a new location stream, updating the aggregate when new locations arrive.
  /// - Returns: The task in which the location stream is running.
  private func startLocationStream() -> Task<Void, any Error> {
    Task {
      var previousLocation = CLLocation(
        latitude: location.latitude,
        longitude: location.longitude)

      let distanceThresholdInMeters = 250.0

      let filterByDistance: @UpdateProcessor (CLLocation) -> Bool = { location in
        guard
          location.distance(from: previousLocation) > distanceThresholdInMeters
        else { return false }

        previousLocation = location

        return true
      }

      guard
        await CLServiceSession.getAuthorizationStatus()
      else { return process(event: .manualize) }

      try await CLLocationUpdate.liveUpdates()
        .compactMap(\.location)
        .filter(filterByDistance)
        .forEach { location = $0.coordinate }
    }
  }
}


extension LocationAggregate {
  /// Begins location tracking, this method has no effect when location tracking is occurring.
  func startTracking() {
    process(event: .automate)
  }
  
  /// Ends location tracking, this method has no effect when no location tracking is occurring.
  func stopTracking() {
    process(event: .manualize)
  }
  
  /// Suspends location tracking, this method has no effect when no location tracking is occurring.
  func suspend() {
    process(event: .suspend)
  }
  
  /// Resumes location tracking, this method has no effect when no location tracking is occurring.
  func resume() {
    process(event: .resume)
  }
  
  /// Sets the aggregate to a new location, this method has no effect when location tracking is occurring.
  /// - Parameter newLocation: The location to set the aggregate to.
  func setLocation(_ newLocation: Coordinate) {
    process(event: .set(newLocation))
  }
}
