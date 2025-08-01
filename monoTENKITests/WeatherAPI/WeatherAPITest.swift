//
// NetworkTest.swift
// monoTENKI
//
// Created by Barreloofy on 7/31/25 at 3:04 PM
//

import Testing
import Foundation
@testable import monoTENKI

struct WeatherAPITest {
  struct DecoderTest {
    @Test func decodeSearch() async throws {
      let url = try #require(Bundle.main.url(forResource: "WeatherAPISearchMockData.json", withExtension: nil))

      let data = try #require(try? Data(contentsOf: url))

      #expect(throws: Never.self) {
        try JSONDecoder().decode(WeatherAPILocations.self, from: data)
      }
    }


    @Test func decodeWeather() async throws {
      let url = try #require(Bundle.main.url(forResource: "WeatherAPIWeatherMockData.json", withExtension: nil))

      let data = try #require(try? Data(contentsOf: url))

      #expect(throws: Never.self) {
        try WeatherAPIWeather.decoder.decode(WeatherAPIWeather.self, from: data)
      }
    }
  }
}
