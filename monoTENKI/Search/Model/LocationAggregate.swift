//
// LocationAggregate.swift
// monoTENKI
//
// Created by Barreloofy on 3/19/25 at 8:11 PM.
//

import CoreLocation

/// An aggregate that manages locaion as a finite state machine.
///
/// The aggregate is in either state:
///   - manual, update aggregate directly.
///   - automatic, the aggregate continuously updates itself.
@Observable
final class LocationAggregate {
  nonisolated
  enum State: Codable {
    case manual, automatic
  }

  enum Event {
    case automate, manualize, suspend, resume, set(Coordinate)
  }

  private var stream: Task<Void, any Error>?

  private var state: State {
    get {
      UserDefaults.standard.codableType(\.locationAggregateState)
    }
    set {
      UserDefaults.standard.setCodable(\.locationAggregateState, value: newValue)
    }
  }

  private(set) var location: Coordinate {
    get {
      access(keyPath: \.location)
      return UserDefaults.standard.codableType(\.location)
    }
    set {
      withMutation(keyPath: \.location) {
        UserDefaults.standard.setCodable(\.location, value: newValue)
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
        startStream()
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
        startStream()
      default: return
      }
    }
  }

  /// Begins a new location stream, updating the aggregate when new locations arrive.
  private func startStream() {
    guard stream?.isCancelled == true || stream == nil else { return }

    stream = Task {
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
        try await CLLocationUpdate.getAuthorization()
      else { return process(event: .manualize) }

      try await CLLocationUpdate.liveUpdates()
        .compactMap(\.location)
        .filter(filterByDistance)
        .forEach { location = $0.makeCoordinate() }
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
