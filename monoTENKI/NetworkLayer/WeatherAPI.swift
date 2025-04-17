//
//  WeatherAPI.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/18/25 at 5:44 PM.
//

import Foundation
/// Concrete URLProvider for WeatherAPI.com
enum WeatherAPI {
  case weather(String)
  case search(String)
}

// MARK: - Implement URLProvider
extension WeatherAPI: URLProvider {
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

  func constructURL() throws -> URL {
    var components = URLComponents()

    components.scheme = "https"
    components.host = "api.weatherapi.com"
    components.path = "/v1/\(service).json"
    components.queryItems = [
      URLQueryItem(name: "key", value: apiKey),
      URLQueryItem(name: "q", value: query),
      URLQueryItem(name: "days", value: "3"),
    ]

    guard let url = components.url else { throw URLError(.badURL) }

    return url
  }
}
