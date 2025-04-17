//
//  AccuWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/14/25 at 12:07 PM.
//

import Foundation
/// Concrete URLProvider for AccuWeather
enum AccuWeather {
  case current(String)
  case hourly12(String)
  case daily5(String)
  case search(String)
}

// MARK: - Implement URLProvider
extension AccuWeather: URLProvider {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "AccuWeatherAPIKey") as! String
  }

  private var service: URLComponents {
    switch self {
    case .current(let query):
      var components = URLComponents()

      components.scheme = "https"
      components.host = "dataservice.accuweather.com"
      components.path = "/currentconditions/v1/\(query)"
      components.queryItems = [
        URLQueryItem(name: "apikey", value: apiKey),
        URLQueryItem(name: "details", value: "true"),
      ]

      return components
    case .hourly12(let query):
      var components = URLComponents()

      components.scheme = "https"
      components.host = "dataservice.accuweather.com"
      components.path = "/forecasts/v1/hourly/12hour/\(query)"
      components.queryItems = [
        URLQueryItem(name: "apikey", value: apiKey),
        URLQueryItem(name: "details", value: "true"),
        URLQueryItem(name: "metric", value: "true"),
      ]

      return components
    case .daily5(let query):
      var components = URLComponents()

      components.scheme = "https"
      components.host = "dataservice.accuweather.com"
      components.path = "/forecasts/v1/daily/5day/\(query)"
      components.queryItems = [
        URLQueryItem(name: "apikey", value: apiKey),
        URLQueryItem(name: "details", value: "true"),
        URLQueryItem(name: "metric", value: "true"),
      ]

      return components
    case .search(let query):
      var components = URLComponents()

      components.scheme = "https"
      components.host = "dataservice.accuweather.com"
      components.path = "/locations/v1/cities/autocomplete"
      components.queryItems = [
        URLQueryItem(name: "apikey", value: apiKey),
        URLQueryItem(name: "q", value: query),
      ]

      return components
    }
  }

  func constructURL() throws -> URL {
    guard let url = service.url else { throw URLError(.badURL) }

    return url
  }
}
