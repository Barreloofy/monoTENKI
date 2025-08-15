//
// WeatherAggregate.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 5:19 PM
//

import Foundation

enum WeatherAggregate {
  case weatherAPI
  case accuWeather

  func fetchWeather(for query: String) async throws -> Weather {
    switch self {
    case .weatherAPI:
      try await WeatherAPI.fetchWeather(for: query).create()
    case .accuWeather:
      try await AccuWeather.fetchWeather(for: query).create()
    }
  }
}
