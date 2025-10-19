//
//  CLLocationCoordinate2D+.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/13/25 at 3:48 PM.
//

import CoreLocation

typealias Coordinate = CLLocationCoordinate2D

extension CLLocationCoordinate2D: @retroactive Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == lhs.longitude
  }
}


extension CLLocationCoordinate2D: @retroactive Codable {
  enum CodingKeys: CodingKey {
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


extension CLLocationCoordinate2D: @retroactive CustomStringConvertible {
  /// `CLLocationCoordinate2D` represented as decimal degrees.
  public var description: String {
    "\(latitude), \(longitude)"
  }
}


extension CLLocationCoordinate2D {
  /// Creates a new instance of `CLLocationCoordinate2D` with `latitude` and `longitude` set to `0`.
  init() {
    self.init(latitude: .zero, longitude: .zero)
  }
}
