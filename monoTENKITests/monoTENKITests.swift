//
//  monoTENKITests.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import XCTest
@testable import monoTENKI
import SwiftUI

final class WeatherTests: XCTestCase {

  func testDecodeAccuWeatherResponse() async {
    do {
      let client = HTTPClient(urlProvider: AccuWeather.current(query: "328328"))
      let weather: [AccuWeatherWeatherCurrent] = try await client.fetch()
      print(weather)
    } catch {
      XCTFail("\(error)")
    }

    do {
      let client = HTTPClient(urlProvider: AccuWeather.hourly(query: "328328"), decoder: AccuWeatherComposite.decoder)
      let weather: [AccuWeatherWeatherHourForecast] = try await client.fetch()
      print(weather)
    } catch {
      XCTFail("\(error)")
    }

    do {
      let client = HTTPClient(urlProvider: AccuWeather.daily(query: "328328"), decoder: AccuWeatherComposite.decoder)
      let weather: AccuWeatherWeatherDayForecast = try await client.fetch()
      print(weather)
    } catch {
      XCTFail("\(error)")
    }
  }

  @MainActor func testSearchModelupdateHistory() {
    let model = SearchModel()

    let historyItems = [
      Location(id: 2801268, name: "London", country: "United Kingdom", latitude: 51.52, longitude: -0.11),
      Location(id: 2145091, name: "Moscow", country: "Russia", latitude: 55.75, longitude: 37.62),
      Location(id: 3125553, name: "Tokyo", country: "Japan", latitude: 35.69, longitude: 139.69),
    ]

    let correctHistoryItems = [
      Location(id: 1284918, name: "Rome", country: "Italy", latitude: 41.9, longitude: 12.48),
      Location(id: 2801268, name: "London", country: "United Kingdom", latitude: 51.52, longitude: -0.11),
      Location(id: 2145091, name: "Moscow", country: "Russia", latitude: 55.75, longitude: 37.62),
      Location(id: 3125553, name: "Tokyo", country: "Japan", latitude: 35.69, longitude: 139.69),
    ]

    let correctHistoryItemsWithUpdatedExisting = [
      Location(id: 2145091, name: "Moscow", country: "Russia", latitude: 55.75, longitude: 37.62),
      Location(id: 1284918, name: "Rome", country: "Italy", latitude: 41.9, longitude: 12.48),
      Location(id: 2801268, name: "London", country: "United Kingdom", latitude: 51.52, longitude: -0.11),
      Location(id: 3125553, name: "Tokyo", country: "Japan", latitude: 35.69, longitude: 139.69),
    ]

    model.history.forEach {
      model.removeHistory(location: $0)
    }

    model.addArraysToHistory(historyItems)

    model.updateHistory(with: Location(id: 1284918, name: "Rome", country: "Italy", latitude: 41.9, longitude: 12.48))

    XCTAssertEqual(model.history, correctHistoryItems)

    model.updateHistory(with: Location(id: 2145091, name: "Moscow", country: "Russia", latitude: 55.75, longitude: 37.62))

    XCTAssertEqual(model.history, correctHistoryItemsWithUpdatedExisting)
  }

  func testWeatherModel() async {
    let model = await WeatherAggregate(source: .WeatherAPI)

    do {
      await model.getWeather(for: "London")
      switch await model.state {
      case .loading:
        print("Loading")
      case .loaded(let currentWeather, let hourForecast, let dayForecast):
        print(currentWeather)
        print(hourForecast)
        print(dayForecast)
      case .error:
        throw URLError(.unknown)
      }
    } catch {
      XCTFail("\(error)")
    }
  }

  func testFetchSearch() async {
    let httpClient = HTTPClient(urlProvider: WeatherAPI.search("London"), decoder: JSONDecoder())

    do {
      _ = try await httpClient.fetch() as Locations
    } catch {
      XCTFail("\(error)")
    }
  }

  func testFetchWeather() async {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let stringDate = try container.decode(String.self)
      let dateFormatter = DateFormatter()

      dateFormatter.timeZone = TimeZone(identifier: "UTC")
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

      if let date = dateFormatter.date(from: stringDate) { return date }
      dateFormatter.dateFormat = "yyyy-MM-dd"
      if let date = dateFormatter.date(from: stringDate) { return date }

      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Date string does not match format expected by formatter")
    }

    let httpClient = HTTPClient(urlProvider: WeatherAPI.weather("London"), decoder: decoder)
    do {
      _ = try await httpClient.fetch() as WeatherAPIWeather
    } catch {
      XCTFail("\(error)")
    }
  }

  func testValidateCurrentDecodable() {
    guard let url = Bundle(for: type(of: self)).url(forResource: "WeatherMock", withExtension: "json") else {
      XCTFail("Could not find WeatherMock.json")
      return
    }

    guard let json = try? Data(contentsOf: url) else {
      XCTFail("Could not initialize data")
      return
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let stringDate = try container.decode(String.self)
      let dateFormatter = DateFormatter()

      dateFormatter.timeZone = TimeZone(identifier: "UTC")
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

      if let date = dateFormatter.date(from: stringDate) { return date }
      dateFormatter.dateFormat = "yyyy-MM-dd"
      if let date = dateFormatter.date(from: stringDate) { return date }

      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Date string does not match format expected by formatter")
    }

    XCTAssertNoThrow(try decoder.decode(WeatherAPIWeather.self, from: json))
  }
}
