//
//  Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/10/25 at 2:18 PM.
//

import Foundation
// MARK: - Weather protocol for the diffrent API services
protocol Weather {
  func createCurrentWeather() -> CurrentWeather
  func createHourForecast() -> Hours
  func createDayForecast() -> Days
}


struct CurrentWeather {
  let location: String
  let condition: String
  let isDay: Int
  let temperatures: Temperatures
  let windDetails: WindDetails
  let downfall: Downfall
}

typealias Hours = [Hour]
struct Hour {
  let time: Date
  let temperatureCelsius: Double
  let isDay: Int
  let condition: String
  let chanceOfRain: Int
  let chanceOfSnow: Int
}

typealias Days = [Day]
struct Day {
  let date: Date
  let temperatureCelsiusAverage: Double
  let temperatureCelsiusLow: Double
  let temperatureCelsiusHigh: Double
  let condition: String
  let chanceOfRain: Int
  let chanceOfSnow: Int
  let precipitationMillimeterTotal: Double
  let snowCentimeterTotal: Double
}

// MARK: - Components
extension CurrentWeather {
  struct Temperatures {
    let temperatureCelsius: Double
    let temperatureCelsiusLow: Double
    let temperatureCelsiusHigh: Double
    let feelsLikeCelsius: Double
    let humidity: Int
  }


  struct WindDetails {
    let windDirection: String
    let windSpeed: Double
    let windGust: Double
  }


  struct Downfall {
    let rate: Double
    let chance: Int
    let total: Double
    let type: String
  }
}
