//
//  Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/10/25 at 2:18 PM.
//

import Foundation
// MARK: - Weather protocol
protocol Weather: Sendable, Decodable {
  func createCurrentWeather() -> CurrentWeather
  func createHourForecast() -> Hours
  func createDayForecast() -> Days
}


struct CurrentWeather {
  let location: String
  let condition: String
  let isDay: Int
  let temperatures: Temperatures
  let precipitation: Precipitation
  let wind: Wind

  struct Temperatures {
    let temperatureCelsius: Double
    let temperatureCelsiusLow: Double
    let temperatureCelsiusHigh: Double
    let feelsLikeCelsius: Double
    let humidity: Int
  }

  struct Precipitation {
    let rateMillimeter: Double
    let chance: Int
    let totalMillimeter: Double
    let type: String
  }

  struct Wind {
    let direction: String
    let speedKilometersPerHour: Double
    let gustKilometersPerHour: Double
  }
}

typealias Hours = [Hour]
struct Hour {
  let time: Date
  let isDay: Int
  let condition: String
  let temperatureCelsius: Double
}

typealias Days = [Day]
struct Day {
  let date: Date
  let condition: String
  let temperatureCelsiusAverage: Double
  let temperatureCelsiusLow: Double
  let temperatureCelsiusHigh: Double
  let precipitationChance: Int
  let precipitationMillimeterTotal: Double
  let type: String
}
