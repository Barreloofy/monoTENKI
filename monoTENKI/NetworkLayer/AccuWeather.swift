//
//  AccuWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/14/25 at 12:07 PM.
//

import Foundation
/// Concrete interface for AccuWeather.
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
    async let current: [AccuWeatherCurrent] = clientCurrent.fetch()

    let clientHours = HTTPClient(
      url: hourlyURL,
      decoder: AccuWeatherComposite.decoder)
    async let hours: [AccuWeatherHourForecast] = clientHours.fetch()

    let clientDays = HTTPClient(
      url: dailyURL,
      decoder: AccuWeatherComposite.decoder)
    async let days: AccuWeatherDayForecast = clientDays.fetch()

    let weather = try await AccuWeatherComposite(
      location: location.administrativeArea.localizedName,
      current: current,
      hourForecast: hours,
      dayForecast: days)
    return weather
  }

  func fetchSearch() async throws -> Locations {
    let client = try HTTPClient(
      url: provideURL(),
      decoder: AccuWeatherLocation.decoder)

    let locations: AccuWeatherLocations = try await client.fetch()

    return locations.compactMap { location in
      Location(
        name: location.localizedName,
        country: location.country.localizedName,
        area: location.administrativeArea.localizedName,
        coordinate: .init(
          latitude: location.geoPosition.latitude,
          longitude: location.geoPosition.longitude))
    }
  }

  func fetchGeo() async throws -> AccuWeatherLocation {
    let client = try HTTPClient(
      url: provideURL(),
      decoder: AccuWeatherLocation.decoder)

    return try await client.fetch()
  }
}
