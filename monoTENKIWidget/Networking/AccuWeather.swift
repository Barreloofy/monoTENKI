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
    case .weather(let query):
      try constructURL(
        host: "dataservice.accuweather.com",
        path: "/currentconditions/v1/\(query)",
        queryItems: [
          "apikey": apiKey,
        ])
    }
  }

  func provideURLs(query: String = "") throws -> [String : URL] {
    switch self {
    case .geo:
      try ["geo": provideURL()]
    case .weather:
      try ["weather": provideURL()]
    }
  }
}
