//
//  LocationModel.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 8:11 PM.
//

import Foundation
import os
/// Location aggregate model
@MainActor
@Observable
class LocationModel {
  var history: Locations

  init() {
    history = []
    retrieve()
  }

  func getLocations(matching query: String) async throws -> Locations {
    let httpClient = HTTPClient(urlProvider: WeatherAPI.search(query))
    return try await httpClient.fetch()
  }

  func updateHistory(with location: Location) {
    for (index, element) in history.enumerated() where element.id == location.id {
      history.remove(at: index)
      history.insert(element, at: 0)

      return
    }

    history.append(location)
  }

  func removeHistory(location: Location) {
    history.removeAll(where: { $0.id == location.id })
  }
}

// MARK: - Persistence
extension LocationModel {
  private var historyURL: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsURL.appending(path: "history")
  }

  private func store() {
    do {
      let data = try JSONEncoder().encode(history)
      try data.write(to: historyURL)
    } catch {
      Logger.location.error("\(error)")
    }
  }

  private func retrieve() {
    do {
      guard FileManager.default.isReadableFile(atPath: historyURL.path()) else {
        throw Errors.fileNotReadable("In: func retrieve() -> Locations")
      }

      let data = try Data(contentsOf: historyURL)
      history = try JSONDecoder().decode(Locations.self, from: data)
    } catch {
      Logger.location.error("\(error)")
    }
  }
}

// MARK: - Errors
extension LocationModel {
  enum Errors: Error {
    case fileNotReadable(String = "")
  }
}

// MARK: - Logger for 'LocationModel'
extension Logger {
  static let location = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LocationModel")
}
