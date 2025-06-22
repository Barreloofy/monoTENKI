//
// WeatherAPIWeather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 12:23 PM
//

import Foundation

struct WeatherAPIWeather: Decodable {
  let current: Current

  struct Current: Decodable {
    let tempC: Double
    let isDay: Int
    let condition: Condition

    struct Condition: Decodable {
      let text: String
    }
  }
}


extension WeatherAPIWeather {
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return decoder
  }
}

typealias WeatherAPILocations = [WeatherAPILocation]
struct WeatherAPILocation: Decodable {
  let id: Int
}
