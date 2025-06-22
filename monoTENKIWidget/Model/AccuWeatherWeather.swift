//
// AccuWeatherWeather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 12:51 PM
//

import Foundation

struct AccuWeatherWeather: Decodable {
  let weatherText: String
  let isDayTime: Bool
  let temperature: Temperature

  struct Temperature: Decodable {
    let metric: Metric

    struct Metric: Decodable {
      let value: Double
    }
  }
}


extension AccuWeatherWeather {
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromPascalCase

    return decoder
  }
}


struct AccuWeatherLocation: Decodable {
  let key: String
}
