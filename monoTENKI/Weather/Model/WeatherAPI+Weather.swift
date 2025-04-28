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
    let day = forecast.days.first!.day

    let isDay = current.isDay == 1 ? true : false

    let temperatures = CurrentWeather.Temperatures(
      temperatureCelsius: current.temperatureCelsius,
      temperatureCelsiusLow: day.temperatureCelsiusLow,
      temperatureCelsiusHigh: day.temperatureCelsiusHigh,
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

    rate = current.precipitationMillimeter

    let snowMillimeterTotal = day.snowCentimeterTotal * 10
    total = day.precipitationMillimeterTotal + snowMillimeterTotal

    if day.chanceOfRain > day.chanceOfSnow {
      chance = day.chanceOfRain
      type = "Rain"
    } else if day.chanceOfRain < day.chanceOfSnow {
      chance = day.chanceOfSnow
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
      isDay: isDay,
      condition: current.condition.text,
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

        let isDay = hour.isDay == 1 ? true : false

        hourForecast.append(monoTENKI.Hour(
          time: hour.time,
          isDay: isDay,
          condition: hour.condition.text,
          temperatureCelsius: hour.temperatureCelsius,
          precipitationChance: hour.chanceOfRain,
          precipitationRateMillimeter: hour.precipitationMillimeter,
          precipitationType: "Rain"))
      }
    }

    return hourForecast
  }

  func createDayForecast() -> Days {
    return Array(forecast.days.dropFirst()).map {
      let day = $0.day

      let chance: Int
      let total: Double
      let type: String

      chance = day.chanceOfRain > day.chanceOfSnow ? day.chanceOfRain : day.chanceOfSnow

      let snowMillimeterTotal = day.snowCentimeterTotal * 10

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

      return monoTENKI.Day(
        date: $0.date,
        condition: day.condition.text,
        temperatureCelsiusAverage: day.temperatureCelsiusAverage,
        temperatureCelsiusLow: day.temperatureCelsiusLow,
        temperatureCelsiusHigh: day.temperatureCelsiusHigh,
        precipitationChance: chance,
        precipitationTotalMillimeter: total,
        precipitationType: type)
    }
  }
}
