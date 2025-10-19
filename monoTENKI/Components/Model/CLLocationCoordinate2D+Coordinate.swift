//
//  CLLocationCoordinate2D+Coordinate.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/13/25 at 3:48 PM.
//

import CoreLocation

extension CLLocationCoordinate2D {
  static func parseCoordinate(from string: String) -> CLLocationCoordinate2D? {
    let components = string.split { $0 == "," || $0 == " " }.compactMap { Double($0) }

    guard components.count == 2 else { return nil }

    return CLLocationCoordinate2DMake(components[0], components[1])
  }
}


extension CLLocationCoordinate2D {
  var stringRepresentation: String {
    "\(latitude), \(longitude)"
  }
}


extension CLLocationCoordinate2D {
  init() {
    self.init(latitude: .zero, longitude: .zero)
  }
}


extension CLLocationCoordinate2D: @retroactive Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == lhs.longitude
  }
}


extension CLLocationCoordinate2D: @retroactive Codable {
  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
    let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)

    self.init(latitude: latitude, longitude: longitude)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
  }
}


typealias Coordinate = CLLocationCoordinate2D
