//
//  AccuWeatherLocation.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/18/25 at 3:06 PM.
//

import Foundation
/// The model produced by decoding 'AccuWeather/locations' JSON response
struct AccuWeatherLocation: Decodable {
  let key: String
  let name: String
  let country: Country

  enum CodingKeys: String, CodingKey {
    case key = "Key"
    case name = "LocalizedName"
    case country = "Country"
  }

  struct Country: Decodable {
    let name: String

    enum CodingKeys: String, CodingKey {
      case name = "LocalizedName"
    }
  }
}
