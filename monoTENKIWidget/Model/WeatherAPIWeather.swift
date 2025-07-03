//
// WeatherAPIWeather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 12:23 PM
//

import Foundation

struct WeatherAPIWeather: Decodable {
  let current: Current
  let forecast: Forecast

  struct Current: Decodable {
    let tempC: Double
    let isDay: Int
    let condition: Condition

    struct Condition: Decodable {
      let text: String
    }
  }

  struct Forecast: Decodable {
    let forecastday: Forecastdays

    typealias Forecastdays = [Forecastday]
    struct Forecastday: Decodable {
      let hour: Hours

      typealias Hours = [Hour]
      struct Hour: Decodable {
        let time: Date
        let chanceOfRain: Int
        let chanceOfSnow: Int
      }
    }
  }
}


typealias WeatherAPILocations = [WeatherAPILocation]
struct WeatherAPILocation: Decodable {
  let id: Int
}


extension WeatherAPIWeather {
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .weatherAPIDateStrategy

    return decoder
  }
}
