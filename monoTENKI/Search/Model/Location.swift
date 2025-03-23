//
//  Location.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 12:47 AM.
//

typealias Locations = [Location]
/// The Model used as the decoded object for location data
struct Location: Codable, Identifiable {
  let id: Int
  let name: String
  let country: String
}
