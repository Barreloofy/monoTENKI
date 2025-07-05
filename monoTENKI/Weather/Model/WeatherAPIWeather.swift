//
//  WeatherAPIWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/30/25.
//

import Foundation

struct WeatherAPIWeather: Weather {
  let location: Location
  let current: Current
  let forecast: Forecast

  struct Condition: Decodable {
    let text: String
  }

  struct Location: Decodable {
    let name: String
    let localtime: Date
  }

  struct Current: Decodable {
    let isDay: Int
    let condition: Condition
    let tempC: Double
    let feelslikeC: Double
    let precipMm: Double
    let humidity: Int
    let windDir: String
    let windKph: Double
    let gustKph: Double
  }

  struct Forecast: Decodable {
    let forecastday: ForecastDays

    typealias ForecastDays = [ForecastDay]
    struct ForecastDay: Decodable {
      let date: Date
      let day: Day
      let hour: Hours

      struct Day: Decodable {
        let condition: Condition
        let avgtempC: Double
        let mintempC: Double
        let maxtempC: Double
        let dailyChanceOfRain: Int
        let dailyChanceOfSnow: Int
        let totalprecipMm: Double
        let totalsnowCm: Double
      }

      typealias Hours = [Hour]
      struct Hour: Decodable {
        let time: Date
        let isDay: Int
        let condition: Condition
        let tempC: Double
        let chanceOfRain: Int
        let chanceOfSnow: Int
        let precipMm: Double
        let snowCm: Double
        let windDir: String
        let windKph: Double
        let gustKph: Double
      }
    }
  }
}
