//
//  Location.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 3:37 PM.
//

import Foundation

typealias Locations = [Location]
struct Location: Codable, Identifiable, Hashable {
  let id = UUID()
  let name: String
  let country: String
  var area: String?
  let coordinate: Coordinate

  var wholeName: String {
    guard let area = area, area != name else { return "\(name) \(country)" }
    return "\(area) \(name) \(country)"
  }

  struct Coordinate: Codable, Hashable {
    let latitude: Double
    let longitude: Double

    var stringRepresentation: String {
      "\(latitude), \(longitude)"
    }
  }

  enum CodingKeys: CodingKey {
    case name
    case country
    case area
    case coordinate
  }
}


// Custom Equatable, Hashable implantation
extension Location {
  static func == (lhs: Location, rhs: Location) -> Bool {
    lhs.wholeName == rhs.wholeName
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(wholeName)
  }
}


// Custom filtering method
extension Locations {
  /// Deduplicates 'Locations' and returns a new 'Locations' array up to the provided length, the default value for 'upTo' is 10.
  func deduplicating(upTo: Int = 10) -> Locations {
    var seen = Set<Location>()
    return Array(self.filter { seen.insert($0).inserted }.prefix(upTo))
  }
}
