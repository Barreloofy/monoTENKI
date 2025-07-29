//
//  History.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/3/25.
//

import Foundation
import os

struct History {
  private(set) var locations = Locations()

  mutating func add(_ newElement: Location) {
    for (index, element) in locations.enumerated() where newElement == element {
      locations.remove(at: index)
      break
    }

    locations.insert(newElement, at: 0)
    if locations.count > 25 { locations.removeLast() }

    save()
  }

  mutating func remove(_ element: Location) {
    locations.removeAll { $0 == element }

    save()
  }

  // store, retrieve locations
  private var historyURL: URL {
    .documentsDirectory.appending(path: "LocationHistory")
  }

  private func save() {
    do {
      let data = try JSONEncoder().encode(locations)
      try data.write(to: historyURL)
    } catch {
      Logger.fileManager.error("\(error)")
    }
  }

  mutating func load() {
    do {
      let data = try Data(contentsOf: historyURL)
      locations = try JSONDecoder().decode(Locations.self, from: data)
    } catch {
      Logger.fileManager.error("\(error)")
    }
  }
}


extension Logger {
  static let fileManager = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "History")
}
