//
//  AccuWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/14/25 at 12:07 PM.
//

import Foundation
import CoreLocation
/// Concrete interface for AccuWeather
enum AccuWeather: URLProvider {
  case weather(query: String)
  case search(query: String)
  case geo(query: String)

  var query: String {
    switch self {
    case .weather(let query): query
    case .search(let query): query
    case .geo(let query): query
    }
  }

  func fetchWeather() async throws -> AccuWeatherComposite {
    let location = try await AccuWeather.geo(query: query).fetchGeo()

    let urlDictionary = try provideURLs(query: location.key)
    guard
      let currentURL = urlDictionary["current"],
      let hourlyURL = urlDictionary["hourly"],
      let dailyURL = urlDictionary["daily"]
    else { throw URLError(.badURL) }

    let clientCurrent = HTTPClient(
      url: currentURL,
      decoder: AccuWeatherComposite.decoder)
    async let current: [AccuWeatherWeatherCurrent] = clientCurrent.fetch()

    let clientHours = HTTPClient(
      url: hourlyURL,
      decoder: AccuWeatherComposite.decoder)
    async let hours: [AccuWeatherWeatherHourForecast] = clientHours.fetch()

    let clientDays = HTTPClient(
      url: dailyURL,
      decoder: AccuWeatherComposite.decoder)
    async let days: AccuWeatherWeatherDayForecast = clientDays.fetch()

    let weather = AccuWeatherComposite(
      location: location.area.name,
      current: try await current,
      forecastHours: try await hours,
      forecastDays: try await days)
    return weather
  }

  func fetchSearch() async throws -> Locations {
    let client = try HTTPClient(url: provideURL())

    let AccuWeatherLocation = try await client.fetch() as AccuWeatherLocations

    return AccuWeatherLocation.compactMap { location in
      Location(
        name: location.name,
        country: location.country.name,
        area: location.area.name,
        coordinate: Location.Coordinate(
          latitude: location.coordinate.latitude,
          longitude: location.coordinate.longitude))
    }
  }

  func fetchGeo() async throws -> AccuWeatherLocation {
    let client = try HTTPClient(url: provideURL())
    return try await client.fetch()
  }
}
