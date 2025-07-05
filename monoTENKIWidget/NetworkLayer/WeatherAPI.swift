//
// WeatherAPI.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 1:06 PM
//

import Foundation

enum WeatherAPI: URLProvider {
  case geo(query: String)
  case weather(query: String)

  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "WeatherAPI.comAPIKey") as! String
  }

  func provideURL() throws -> URL {
    let service: String
    let query: String

    switch self {
    case .geo(let value):
      service = "search"
      query = value
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
        "days": "1",
      ])
  }
  
  func provideURLs(query: String = "") throws -> [String : URL] {
    switch self {
    case .geo: try ["geo": provideURL()]
    case .weather: try ["weather": provideURL()]
    }
  }
}
