//
//  AccuWeather+URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 2:25 PM.
//

import Foundation

// MARK: - Implement URLProvider
extension AccuWeather {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "AccuWeatherAPIKey") as! String
  }
  
  func provideURL() throws -> URL {
    switch self {
    case .weather:
      throw URLError(.badURL)
    case .search:
      return try constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/search",
        parameters: [
          "apikey": apiKey,
          "q": query,
        ])
    case .geo:
      return try constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/geoposition",
        parameters: [
          "apikey": apiKey,
          "q": query,
        ])
    }
  }

  func provideURLs(query: String) throws -> [String: URL] {
    var urlDictionary: [String: URL] = [:]

    switch self {
    case .weather:
      try urlDictionary["current"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/currentconditions/v1/\(query)",
        parameters: [
          "apikey": apiKey,
          "details": "true",
        ])

      try urlDictionary["hourly"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/hourly/12hour/\(query)",
        parameters: [
          "apikey": apiKey,
          "details": "true",
          "metric": "true",
        ])


      try urlDictionary["daily"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/daily/5day/\(query)",
        parameters: [
          "apikey": apiKey,
          "details": "true",
          "metric": "true",
        ])
    case .search(let query):
      try urlDictionary["search"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/autocomplete",
        parameters: [
          "apikey": apiKey,
          "q": query,
        ])
    case .geo(query: let query):
      try urlDictionary["searchGeo"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/geoposition",
        parameters: [
          "apikey": apiKey,
          "q": query,
        ])
    }

    return urlDictionary
  }
}
