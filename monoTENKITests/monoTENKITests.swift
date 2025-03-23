//
//  monoTENKITests.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import XCTest
@testable import monoTENKI
import SwiftUICore

final class WeatherTests: XCTestCase {

  func testWeatherModel() async {
    @State var model = await WeatherModel()

    do {
      try await model.getWeather(for: "London")
      await print(model.currentWeather.temperatures.temperatureCelsius)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testLocationModel() async {
    @State var model = await LocationModel()

    do {
      let data = try await model.getLocations(matching: "London")
      print(data)
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
      _ = try await httpClient.fetch() as Weather
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

    XCTAssertNoThrow(try decoder.decode(Weather.self, from: json))
  }
}
