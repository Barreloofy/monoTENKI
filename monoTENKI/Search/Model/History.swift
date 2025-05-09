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

  // MARK: - store, retrieve locations
  private var historyFileURL: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsURL.appending(path: "locationHistory")
  }

  private func save() {
    do {
      let data = try JSONEncoder().encode(locations)
      try data.write(to: historyFileURL)
    } catch {
      Logger.fileManager.error("\(error)")
    }
  }

  mutating func load() {
    do {
      locations = try JSONDecoder().decode(Locations.self, from: Data(contentsOf: historyFileURL))
    } catch {
      Logger.fileManager.error("\(error)")
    }
  }
}


extension Logger {
  static let fileManager = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "FileManager")
}
