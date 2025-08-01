//
//  AccuWeather+URLProvider.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/20/25 at 2:25 PM.
//

import Foundation

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
      try urlDictionary[Self.currentKey] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/currentconditions/v1/\(query)",
        queryItems: [
          "apikey": apiKey,
          "details": "true",
        ])

      try urlDictionary[Self.hourlyKey] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/hourly/12hour/\(query)",
        queryItems: [
          "apikey": apiKey,
          "details": "true",
          "metric": "true",
        ])


      try urlDictionary[Self.dailyKey] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/forecasts/v1/daily/5day/\(query)",
        queryItems: [
          "apikey": apiKey,
          "details": "true",
          "metric": "true",
        ])

    case .search(let query):
      try urlDictionary[Self.searchKey] = constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/autocomplete",
        queryItems: [
          "apikey": apiKey,
          "q": query,
        ])

    case .geo(let query):
      try urlDictionary[Self.geoKey] = constructURL(
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
