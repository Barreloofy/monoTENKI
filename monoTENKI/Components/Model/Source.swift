//
//  Source.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/19/25 at 2:01 AM.
//

import SwiftUI

actor Source {
  private init() {}

  static var value: APISource = UserDefaults.standard.source(forKey: "source") {
    didSet { UserDefaults.standard.set(value.rawValue, forKey: "source") }
  }
}

enum APISource: String, Codable {
  case WeatherAPI
  case AccuWeather
}

// MARK: - Allows simple storing and retrieval of type 'APISource' values
extension UserDefaults {
  func source(forKey key: String) -> APISource {
    guard let rawValue = string(forKey: key) else { return .WeatherAPI }

    guard let source = APISource(rawValue: rawValue) else { return .WeatherAPI }

    return source
  }
}
