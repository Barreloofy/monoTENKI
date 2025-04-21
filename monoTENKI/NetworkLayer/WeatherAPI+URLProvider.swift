//
//  WeatherAPI+URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 2:31 PM.
//

import Foundation

// MARK: - Implement URLProvider
extension WeatherAPI {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "WeatherAPI.comAPIKey") as! String
  }

  private var service: String {
    switch self {
    case .weather: "forecast"
    case .search: "search"
    }
  }

  private var query: String {
    switch self {
    case .weather(let query), .search(let query): query
    }
  }

  func provideURL() throws -> URL {
    return try constructURL(
      host: "api.weatherapi.com",
      path: "/v1/\(service).json",
      parameters: [
        "key": apiKey,
        "q": query,
        "days": "3",
      ])
  }

  func provideURLs(query: String) throws -> [String : URL] {
    return try ["weather": provideURL()]
  }
}
