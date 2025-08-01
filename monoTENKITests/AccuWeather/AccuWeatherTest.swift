//
// AccuWeatherTest.swift
// monoTENKI
//
// Created by Barreloofy on 8/1/25 at 1:59 PM
//

import Testing
import Foundation
@testable import monoTENKI

struct AccuWeatherTest {
  struct DecoderTest {
    @Test func decodeLocation() async throws {
      let url = try #require(Bundle.main.url(forResource: "AccuWeatherLocationMockData.json", withExtension: nil))

      let data = try #require(try? Data(contentsOf: url))

      #expect(throws: Never.self) {
        try AccuWeatherLocation.decoder.decode(AccuWeatherLocation.self, from: data)
      }
    }


    @Test func decodeWeatherCurrent() async throws {
      let url = try #require(Bundle.main.url(forResource: "AccuWeatherCurrentMockData.json", withExtension: nil))

      let data = try #require(try? Data(contentsOf: url))

      #expect(throws: Never.self) {
        try AccuWeatherComposite.decoder.decode([AccuWeatherCurrent].self, from: data)
      }
    }


    @Test func decodeWeatherHour() async throws {
      let url = try #require(Bundle.main.url(forResource: "AccuWeatherHourMockData.json", withExtension: nil))

      let data = try #require(try? Data(contentsOf: url))

      #expect(throws: Never.self) {
        try AccuWeatherComposite.decoder.decode([AccuWeatherHourForecast].self, from: data)
      }
    }


    @Test func decodeWeatherDay() async throws {
      let url = try #require(Bundle.main.url(forResource: "AccuWeatherDayMockData.json", withExtension: nil))

      let data = try #require(try? Data(contentsOf: url))

      #expect(throws: Never.self) {
        try AccuWeatherComposite.decoder.decode(AccuWeatherDayForecast.self, from: data)
      }
    }
  }
}
