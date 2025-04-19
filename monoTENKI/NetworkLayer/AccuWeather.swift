//
//  AccuWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/14/25 at 12:07 PM.
//

import Foundation
/// Concrete URLProvider for AccuWeather
enum AccuWeather: API, URLProvider {
  case weather(query: String)
  case search(query: String)
  case searchGeo(query: String)
}

// MARK: - Implement URLProvider
extension AccuWeather {
  private var apiKey: String {
    Bundle.main.object(forInfoDictionaryKey: "AccuWeatherAPIKey") as! String
  }

  var query: String {
    switch self {
    case .search(let query): query
    case .searchGeo(let query): query
    case .weather(query: let query): query
    }
  }

  func provideURL() throws -> URL {
    switch self {
    case .weather:
      throw URLError(.badURL)
    case .search(let query):
      return try constructURL(
        host: "dataservice.accuweather.com",
        path: "/locations/v1/cities/autocomplete",
        parameters: [
          "apikey": apiKey,
          "q": query,
        ])
    case .searchGeo(query: let query):
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
    case .searchGeo(query: let query):
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


extension AccuWeather {
  func fetch() async throws -> AccuWeatherComposite {
    let httpClientSearchGeo = try HTTPClient(url: AccuWeather.searchGeo(query: query).provideURL())

    let accuWeatherLocation: AccuWeatherLocation = try await httpClientSearchGeo.fetch()
    let locationKey = accuWeatherLocation.key

    let urlDictionary = try provideURLs(query: locationKey)

    guard
      let currentURL = urlDictionary["current"],
      let hourlyURL = urlDictionary["hourly"],
      let dailyURL = urlDictionary["daily"]
    else { throw URLError(.badURL) }

    let httpClientCurrent = HTTPClient(
      url: currentURL,
      decoder: AccuWeatherComposite.decoder)
    async let accuWeatherCurrent: [AccuWeatherWeatherCurrent] = httpClientCurrent.fetch()

    let httpClientHour = HTTPClient(
      url: hourlyURL,
      decoder: AccuWeatherComposite.decoder)
    async let accuWeatherHour: [AccuWeatherWeatherHourForecast] = httpClientHour.fetch()

    let httpClientDay = HTTPClient(
      url: dailyURL,
      decoder: AccuWeatherComposite.decoder)
    async let accuWeatherDay: AccuWeatherWeatherDayForecast = httpClientDay.fetch()

    let compositeWeather = AccuWeatherComposite(
      location: accuWeatherLocation.name,
      current: try await accuWeatherCurrent,
      forecastHours: try await accuWeatherHour,
      forecastDays: try await accuWeatherDay)

    return compositeWeather
  }
}
