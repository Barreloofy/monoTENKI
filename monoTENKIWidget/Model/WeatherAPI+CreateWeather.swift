//
// WeatherAPI+CreateWeather.swift
// monoTENKI
//
// Created by Barreloofy on 7/4/25 at 10:07 AM
//

import Foundation

extension WeatherAPIWeather {
  func create() throws -> Weather {
    let oneHourInSeconds = TimeInterval(3_600)
    let nextHour = location.localtime.addingTimeInterval(oneHourInSeconds)

    guard
      let today = forecast.forecastday.first,
      let hour = today.hour.first(where: { $0.time.compareDateComponent(.hour, with: nextHour) })
    else {
      throw DecodingError.valueNotFound(
        WeatherAPIWeather.Forecast.self,
        .init(codingPath: [], debugDescription: "Nil found while unwrapping"))
    }

    let isDay = current.isDay == 1 ? true : false
    let chance = hour.chanceOfRain > hour.chanceOfSnow ? hour.chanceOfRain : hour.chanceOfSnow

    return Weather(
      condition: current.condition.text,
      isDay: isDay,
      temperatureCelsius: current.tempC,
      precipitationChance: chance)
  }
}


extension WeatherAPIWeather {
  static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .weatherAPIDateStrategy

    return decoder
  }()
}
