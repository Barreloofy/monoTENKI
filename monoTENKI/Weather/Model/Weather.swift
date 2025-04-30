//
//  Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/10/25 at 2:18 PM.
//

import Foundation

protocol Weather: Sendable, Decodable {
  func createCurrentWeather() -> CurrentWeather
  func createHourForecast() -> Hours
  func createDayForecast() -> Days
}


struct CurrentWeather {
  let location: String
  let isDay: Bool
  let condition: String
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
    let chance: Int
    let rateMillimeter: Double
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
  let isDay: Bool
  let condition: String
  let temperatureCelsius: Double
  let precipitationChance: Int
  let precipitationRateMillimeter: Double
  let precipitationType: String
}


typealias Days = [Day]
struct Day {
  let date: Date
  let condition: String
  let temperatureCelsiusAverage: Double
  let temperatureCelsiusLow: Double
  let temperatureCelsiusHigh: Double
  let precipitationChance: Int
  let precipitationTotalMillimeter: Double
  let precipitationType: String
}
