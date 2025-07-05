//
// WeatherAPIWeather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 12:23 PM
//

import Foundation

typealias WeatherAPILocations = [WeatherAPILocation]
struct WeatherAPILocation: Decodable {
  let id: Int
}


struct WeatherAPIWeather: Decodable, CreateWeather {
  let location: Location
  let current: Current
  let forecast: Forecast

  struct Location: Decodable {
    let localtime: Date
  }

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
