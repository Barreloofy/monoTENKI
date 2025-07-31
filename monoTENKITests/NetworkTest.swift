//
// NetworkTest.swift
// monoTENKI
//
// Created by Barreloofy on 7/31/25 at 3:04 PM
//

import Testing
import Foundation
@testable import monoTENKI

struct NetworkTest {
  @Test func validateWeatherAPI() async throws {
    await #expect(throws: Never.self) {
      try await WeatherAPI.fetchWeather(for: "London")
    }

    await #expect(throws: URLError(.badServerResponse)) {
      try await WeatherAPI.fetchWeather(for: "")
    }
  }
}


@Test func decodeWeatherAPIForecast() async throws {
  let url = try #require(Bundle.main.url(forResource: "WeatherAPIMockData.json", withExtension: nil))

  let data = try #require(try? Data(contentsOf: url))

  #expect(throws: Never.self) {
    try WeatherAPIWeather.decoder.decode(WeatherAPIWeather.self, from: data)
  }
}
