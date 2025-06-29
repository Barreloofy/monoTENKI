//
//  Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/10/25 at 2:18 PM.
//

import Foundation

protocol Weather: Sendable, Decodable {
  func createCurrentWeather() throws -> CurrentWeather
  func createHourForecast() throws -> Hours
  func createDayForecast() throws -> Days
}


struct CurrentWeather: Equatable {
  let location: String
  let isDay: Bool
  let condition: String
  let temperatures: Temperatures
  let precipitation: Precipitation
  let wind: Wind

  struct Temperatures: Equatable {
    let celsius: Double
    let celsiusLow: Double
    let celsiusHigh: Double
    let feelsLikeCelsius: Double
    let humidity: Int
  }

  struct Precipitation: Equatable {
    let chance: Int
    let rateMillimeter: Double
    let totalMillimeter: Double
    let type: String
  }

  struct Wind: Equatable {
    let direction: String
    let speedKilometersPerHour: Double
    let gustKilometersPerHour: Double
  }
}


typealias Hours = [Hour]
struct Hour: Equatable, Identifiable {
  let time: Date
  let isDay: Bool
  let condition: String
  let temperatureCelsius: Double
  let precipitation: Precipitation
  let wind: Wind

  var id: Date { time }

  struct Precipitation: Equatable {
    let chance: Int
    let rateMillimeter: Double
    let type: String
  }

  struct Wind: Equatable {
    let direction: String
    let speedKilometersPerHour: Double
    let gustKilometersPerHour: Double
  }
}


typealias Days = [Day]
struct Day: Equatable, Identifiable {
  let date: Date
  let condition: String
  let temperatures: Temperatures
  let precipitation: Precipitation

  var id: Date { date }

  struct Temperatures: Equatable {
    let celsiusAverage: Double
    let celsiusLow: Double
    let celsiusHigh: Double
  }

  struct Precipitation: Equatable {
    let chance: Int
    let totalMillimeter: Double
    let type: String
  }
}
