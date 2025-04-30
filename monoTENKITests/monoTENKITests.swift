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
  func testWeatherApiForecastDecode() {
    guard let url = Bundle(for: type(of: self)).url(forResource: "WeatherApiForecast", withExtension: "json") else {
      XCTFail("Could not find file 'WeatherApiForecast'")
      return
    }

    do {
      let data = try Data(contentsOf: url)
      _ = try WeatherAPIWeather.decoder.decode(WeatherAPIWeather.self, from: data)
    } catch {
      XCTFail("\(error)")
    }
  }

  func testAccuWeatherCurrentDecode() {
    guard let url = Bundle(for: type(of: self)).url(forResource: "AccuWeatherCurrent", withExtension: "json") else {
      XCTFail("Could not find file 'AccuWeatherCurrent'")
      return
    }

    do {
      let data = try Data(contentsOf: url)
      _ = try AccuWeatherComposite.decoder.decode([AccuWeatherCurrent].self, from: data)
    } catch {
      XCTFail("\(error)")
    }
  }
}
