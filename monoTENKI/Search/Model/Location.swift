//
//  Location.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 3:37 PM.
//

import CoreLocation
import SwiftData

typealias Locations = [Location]

@Model
final class Location {
  #Unique<Location>([\.name, \.country], [\.area])

  var accessDate = Date()
  var name: String
  var country: String
  var area: String?
  var coordinate: CLLocationCoordinate2D

  var completeName: String {
    guard let area = area, area != name else { return "\(name) \(country)" }
    return "\(area) \(name) \(country)"
  }

  init(name: String, country: String, area: String? = nil, coordinate: CLLocationCoordinate2D) {
    self.name = name
    self.country = country
    self.area = area
    self.coordinate = coordinate
  }
}


extension Location {
  static let descriptor: FetchDescriptor<Location> = {
    var descriptor = FetchDescriptor<Location>(
      sortBy: [.init(\.accessDate, order: .reverse)])

    descriptor.fetchLimit = 25

    return descriptor
  }()
}
