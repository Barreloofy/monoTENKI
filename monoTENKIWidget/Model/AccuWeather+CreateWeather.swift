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
    guard let current = current.first else { throw UnwrappingError(type: [AccuWeatherCurrent].self) }

    guard let nextHour = hours.first else { throw UnwrappingError(type: [AccuWeatherHour].self) }

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
