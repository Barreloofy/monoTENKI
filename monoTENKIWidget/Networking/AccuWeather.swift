//
// AccuWeather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 3:12 PM
//

import Foundation

enum AccuWeather: URLProvider {
  case geo(query: String)
  case weather(query: String)

  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "AccuWeatherAPIKey") as! String
  }

  func provideURL() throws -> URL {
    switch self {
    case .geo(let query):
      try constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/geoposition",
        queryItems: [
          "apikey": apiKey,
          "q": query,
        ])
    case .weather: throw URLError(.badURL)
    }
  }

  func provideURLs(query: String = "") throws -> [String : URL] {
    switch self {
    case .geo:
      return try ["geo": provideURL()]
    case .weather(let baseQuery):
      let currentURL = try constructURL(
        host: "dataservice.accuweather.com",
        path: "/currentconditions/v1/\(baseQuery)",
        queryItems: [
          "apikey": apiKey,
        ])

      let hourURL = try constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/hourly/1hour/\(baseQuery)",
        queryItems: [
          "apikey": apiKey,
          "details": "false",
          "metric": "true",
        ])

      return ["current": currentURL, "hour": hourURL]
    }
  }
}
