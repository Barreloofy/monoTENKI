//
//  Source.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/19/25 at 2:01 AM.
//

import SwiftUI
// MARK: - The environment-value that serves as the source of truth for the API source
extension EnvironmentValues {
  @Entry var source = Source.WeatherAPI
}


enum Source: String {
  case WeatherAPI
  case AccuWeather
}

// MARK: - Allows simple storing and retrieval of type 'Source' values
extension UserDefaults {
  func source(forKey key: String) -> Source {
    guard let rawValue = string(forKey: key) else { return .WeatherAPI }

    guard let source = Source(rawValue: rawValue) else { return .WeatherAPI }

    return source
  }
}
