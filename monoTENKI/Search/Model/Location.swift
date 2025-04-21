//
//  Location.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 3:37 PM.
//

import Foundation

typealias Locations = [Location]
struct Location: Codable, Equatable, Identifiable {
  let source: Source
  let id: Int
  let name: String
  let country: String
  let area: String
  let latitude: Double
  let longitude: Double

  var coordinate: String {
    "\(latitude), \(longitude)"
  }

  var locationKey: String {
    switch source {
    case .WeatherAPI:
      "id:\(id)"
    case .AccuWeather:
      "\(name) \(id)"
    }
  }

  var completeName: String {
    if name == area {
      "\(name)\(country)"
    } else {
      "\(name)\(area) \(country)"
    }
  }

  init(source: Source, id: Int, name: String, country: String, area: String = "", latitude: Double, longitude: Double) {
    self.source = source
    self.id = id
    self.name = name
    self.country = country
    self.area = area
    self.latitude = latitude
    self.longitude = longitude
  }

  init?(source: Source, id: String, name: String, country: String, area: String = "", latitude: Double, longitude: Double) {
    guard let id = Int(id) else { return nil }

    self.source = source
    self.id = id
    self.name = name
    self.country = country
    self.area = area
    self.latitude = latitude
    self.longitude = longitude
  }
}
