//
//  AccuWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/14/25 at 12:07 PM.
//

import Foundation

/// Concrete interface for AccuWeather.
enum AccuWeather {
  enum Service: URLProvider {
    case weather
    case search(query: String)
    case geo(query: String)
  }

  static func fetchWeather(for query: String) async throws -> AccuWeatherComposite {
    let location = try await AccuWeather.fetchGeo(for: query)

    let urlDictionary = try Service.weather.provideURLs(query: location.key)
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

  static func fetchSearch(for query: String) async throws -> Locations {
    let client = try HTTPClient(
      url: Service.search(query: query).provideURL(),
      decoder: AccuWeatherLocation.decoder)

    let locations: AccuWeatherLocations = try await client.fetch()

    return locations.map { location in
      Location(
        name: location.localizedName,
        country: location.country.localizedName,
        area: location.administrativeArea.localizedName,
        coordinate: .init(
          latitude: location.geoPosition.latitude,
          longitude: location.geoPosition.longitude))
    }
  }

  static func fetchGeo(for query: String) async throws -> AccuWeatherLocation {
    let client = try HTTPClient(
      url: Service.geo(query: query).provideURL(),
      decoder: AccuWeatherLocation.decoder)

    return try await client.fetch()
  }
}
