//
//  LocationAggregate.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 8:11 PM.
//

import CoreLocation

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

  private func process(event: Event) {
    switch state {
    case .manual:
      switch event {
      case .automate:
        state = .automatic
        stream = getLocationStream()
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
        if stream?.isCancelled ?? true { stream = getLocationStream() }
      default: return
      }
    }
  }

  private func getLocationStream() -> Task<Void, any Error> {
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

      try await CLLocationUpdate.liveUpdates()
        .compactMap(\.location)
        .filter(filterByDistance)
        .forEach { location = $0.coordinate }
    }
  }
}


extension LocationAggregate {
  func startTracking() {
    process(event: .automate)
  }

  func stopTracking() {
    process(event: .manualize)
  }

  func suspend() {
    process(event: .suspend)
  }

  func resume() {
    process(event: .resume)
  }

  func setLocation(_ newLocation: Coordinate) {
    process(event: .set(newLocation))
  }
}


// Change with effect
// idle > tracking
// tracking > idle
// tracking > suspend
// suspend > tracking
