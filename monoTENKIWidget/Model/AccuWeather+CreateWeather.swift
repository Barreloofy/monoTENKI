//
// AccuWeather+CreateWeather.swift
// monoTENKI
//
// Created by Barreloofy on 7/4/25 at 11:01 AM
//

import Foundation

struct AccuWeatherComposite: CreateWeather {
  let current: [AccuWeatherCurrent]
  let hours: [AccuWeatherHour]

  func create() throws -> Weather {
    guard let current = current.first else {
      throw DecodingError.valueNotFound(
        [AccuWeatherCurrent].self,
        .init(codingPath: [], debugDescription: "Nil found 'current.first'"))
    }

    guard let nextHour = hours.first else {
      throw DecodingError.valueNotFound(
        [AccuWeatherHour].self,
        .init(codingPath: [], debugDescription: "Nil found 'hours.first'"))
    }

    return Weather(
      condition: current.weatherText,
      isDay: current.isDayTime,
      temperatureCelsius: current.temperature.metric.value,
      precipitationChance: nextHour.precipitationProbability)
  }
}


extension AccuWeatherComposite {
  static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromPascalCase

    return decoder
  }()
}
