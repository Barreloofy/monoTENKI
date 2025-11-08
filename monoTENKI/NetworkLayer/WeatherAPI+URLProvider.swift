//
//  WeatherAPI+URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 2:31 PM.
//

import Foundation

extension WeatherAPI.Service {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "WeatherAPI.comAPIKey") as! String
  }

  func provideURL() throws -> URL {
    let service: String
    let query: String

    switch self {
    case .search(let value):
      service = "search"
      query = value.description

    case .weather(let value):
      service = "forecast"
      query = value
    }

    return try constructURL(
      host: "api.weatherapi.com",
      path: "/v1/\(service).json",
      queryItems: [
        "key": apiKey,
        "q": query,
        "days": "3",
      ])
  }

  func provideURLs(query: String) throws -> [String : URL] {
    throw URLError(.badURL)
  }
}
