//
//  AccuWeather+URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 2:25 PM.
//

import Foundation

// Implement URLProvider
extension AccuWeather.Service {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "AccuWeatherAPIKey") as! String
  }
  
  func provideURL() throws -> URL {
    switch self {
    case .weather:
      throw URLError(.badURL)
    case .search(let query):
      try constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/search",
        queryItems: [
          "apikey": apiKey,
          "q": query,
        ])
    case .geo(let query):
      try constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/geoposition",
        queryItems: [
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
        queryItems: [
          "apikey": apiKey,
          "details": "true",
        ])

      try urlDictionary["hourly"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/hourly/12hour/\(query)",
        queryItems: [
          "apikey": apiKey,
          "details": "true",
          "metric": "true",
        ])


      try urlDictionary["daily"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/daily/5day/\(query)",
        queryItems: [
          "apikey": apiKey,
          "details": "true",
          "metric": "true",
        ])
    case .search(let query):
      try urlDictionary["search"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/autocomplete",
        queryItems: [
          "apikey": apiKey,
          "q": query,
        ])
    case .geo(query: let query):
      try urlDictionary["searchGeo"] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/geoposition",
        queryItems: [
          "apikey": apiKey,
          "q": query,
        ])
    }

    return urlDictionary
  }
}
