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
  var results: Locations = []
  private(set) var history: Locations = []

  init() {
    retrieve()
  }

  /// Returns the content of the 'history' property if condition is true otherwise the content of 'results' property
  func getContent(condition: Bool) -> Locations {
    condition ? history.deduplicating() : results.deduplicating()
  }

  func getLocations(matching query: String) async throws {
    guard !query.isEmpty else { return }

    switch Source.value {
    case .WeatherAPI:
      results = try await WeatherAPI.search(query: query).fetchSearch()
    case .AccuWeather:
      results = try await AccuWeather.search(query: query).fetchSearch()
    }
  }

  func updateHistory(with location: Location) {
    for (index, element) in history.enumerated() where element == location {
      history.remove(at: index)
      break
    }

    history.insert(location, at: 0)

    store()
  }

  func removeHistory(location: Location) {
    history.removeAll { $0 == location }

    store()
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

  func retrieve() {
    do {
      guard FileManager.default.isReadableFile(atPath: historyURL.path()) else {
        throw URLError(.noPermissionsToReadFile)
      }
      history = try JSONDecoder().decode(Locations.self, from: Data(contentsOf: historyURL))
    } catch {
      Logger.search.error("\(error.localizedDescription)")
    }
  }
}

// MARK: - Logger for 'Search'
extension Logger {
  static let search = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Search")
}

#if DEBUG
extension SearchModel {
  func addArraysToHistory(_ locations: Locations) {
    history.append(contentsOf: locations)
  }
}
#endif
