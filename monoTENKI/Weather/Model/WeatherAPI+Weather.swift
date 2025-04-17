//
//  WeatherAPI+Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/10/25 at 7:26 PM.
//

import Foundation
// MARK: - Implement 'Weather' protocol conformes
extension WeatherAPIWeather {
  func createCurrentWeather() -> CurrentWeather {
    let details = forecast.days.first!.details

    let temperatures = CurrentWeather.Temperatures(
      temperatureCelsius: current.temperatureCelsius,
      temperatureCelsiusLow: details.temperatureCelsiusLow,
      temperatureCelsiusHigh: details.temperatureCelsiusHigh,
      feelsLikeCelsius: current.feelsLikeCelsius,
      humidity: current.humidity)

    let wind = CurrentWeather.Wind(
      direction: current.WindDirection,
      speedKilometersPerHour: current.windKilometersPerHour,
      gustKilometersPerHour: current.gustKilometersPerHour)

    let rate: Double
    let chance: Int
    let total: Double
    let type: String

    let snowMillimeterTotal = details.snowCentimeterTotal * 10
    total = details.precipitationMillimeterTotal + snowMillimeterTotal
    rate = current.precipitationMillimeter

    if details.chanceOfRain > details.chanceOfSnow {
      chance = details.chanceOfRain
      type = "Rain"
    } else if details.chanceOfRain < details.chanceOfSnow {
      chance = details.chanceOfSnow
      type = "Snow"
    } else {
      chance = 0
      type = "--"
    }

    let precipitation = CurrentWeather.Precipitation(
      rateMillimeter: rate,
      chance: chance,
      totalMillimeter: total,
      type: type)

    return CurrentWeather(
      location: location.name,
      condition: current.condition.text,
      isDay: current.isDay,
      temperatures: temperatures,
      precipitation: precipitation,
      wind: wind)
  }

  func createHourForecast() -> monoTENKI.Hours {
    let twelveHoursInSeconds: TimeInterval = 43_200
    var hourForecast: monoTENKI.Hours = []

    for day in forecast.days {
      for hour in day.hours {
        guard hourForecast.count < 12 else { return hourForecast }

        guard hour.time > location.time &&
             hour.time <= location.time.addingTimeInterval(twelveHoursInSeconds)
        else { continue }

        hourForecast.append(monoTENKI.Hour(
          time: hour.time,
          isDay: hour.isDay,
          condition: hour.condition.text,
          temperatureCelsius: hour.temperatureCelsius))
      }
    }

    return hourForecast
  }

  func createDayForecast() -> Days {
    return Array(forecast.days.dropFirst()).map {
      let day = $0.details

      let type: String
      let snowMillimeterTotal = day.snowCentimeterTotal * 10
      let chance: Int
      let total: Double

      chance = day.chanceOfRain > day.chanceOfSnow ? day.chanceOfRain : day.chanceOfSnow

      if day.precipitationMillimeterTotal > snowMillimeterTotal {
        type = "Rain"
        total = day.precipitationMillimeterTotal
      } else if day.precipitationMillimeterTotal < snowMillimeterTotal {
        type = "Snow"
        total = snowMillimeterTotal
      } else {
        type = "--"
        total = 0
      }

      return Day(
        date: $0.date,
        condition: day.condition.text,
        temperatureCelsiusAverage: day.temperatureCelsiusAverage,
        temperatureCelsiusLow: day.temperatureCelsiusLow,
        temperatureCelsiusHigh: day.temperatureCelsiusHigh,
        precipitationChance: chance,
        precipitationMillimeterTotal: total,
        type: type)
    }
  }
}
