//
//  SearchModel.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/25/25 at 11:51 AM.
//

import Foundation
import os
/// View dependent model for 'Search' view
@MainActor
@Observable
class SearchModel {
  private(set) var results: Locations = []
  private(set) var history: Locations = []

  init() {
    retrieve()
  }

  func getLocations(matching query: String) async throws {
    let httpClient = HTTPClient(urlProvider: WeatherAPI.search(query))
    results = try await httpClient.fetch()
  }

  func updateHistory(with location: Location) {
    for (index, element) in history.enumerated() where element == location {
      history.remove(at: index)
      break
    }
    history.insert(location, at: 0)
  }

  func removeHistory(location: Location) {
    history.removeAll { $0 == location }
  }
}

// MARK: - Persistence
extension SearchModel {
  private var historyURL: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsURL.appending(path: "history")
  }

  private func store() {
    do {
      let data = try JSONEncoder().encode(history)
      try data.write(to: historyURL)
    } catch {
      Logger.search.error("\(error)")
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
      Logger.search.error("\(error)")
    }
  }
}

// MARK: - Errors
extension SearchModel {
  enum Errors: Error {
    case fileNotReadable(String = "")
  }
}

// MARK: - Logger for 'LocationModel'
extension Logger {
  static fileprivate let search = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SearchModel")
}

#if DEBUG
extension SearchModel {
  func addArraysToHistory(_ locations: Locations) {
    history.append(contentsOf: locations)
  }
}
#endif
