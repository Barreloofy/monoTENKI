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

    let windDetails = CurrentWeather.WindDetails(
      windDirection: current.WindDirection,
      windSpeed: current.windKilometrePerHour,
      windGust: current.gustKilometrePerHour)

    let rate: Double
    let chance: Int
    let total: Double
    let type: String

    let snowMillimeterTotal = details.snowCentimeterTotal * 10
    total = details.precipitationMillimeterTotal + snowMillimeterTotal
    rate = current.precipitationMillimeter

    if details.chanceOfRain > details.chanceOfSnow {
      chance = details.chanceOfRain
      type = "rain"
    } else if details.chanceOfRain < details.chanceOfSnow {
      chance = details.chanceOfSnow
      type = "snow"
    } else {
      chance = 0
      type = "--"
    }

    let downfall = CurrentWeather.Downfall(
      rate: rate,
      chance: chance,
      total: total,
      type: type)

    return CurrentWeather(
      location: location.name,
      condition: current.condition.text,
      isDay: current.isDay,
      temperatures: temperatures,
      windDetails: windDetails,
      downfall: downfall)
  }

  func createHourForecast() -> monoTENKI.Hours {
    let twelveHoursinSeconds: TimeInterval = 43_200
    var hourForecast: monoTENKI.Hours = []

    for day in forecast.days {
      guard hourForecast.count < 12 else { return hourForecast }

      for hour in day.hours {
        guard hourForecast.count < 12 else { return hourForecast }

        guard hour.time > location.time &&
             hour.time <= location.time.addingTimeInterval(twelveHoursinSeconds)
        else { continue }

        hourForecast.append(monoTENKI.Hour(
          time: hour.time,
          temperatureCelsius: hour.temperatureCelsius,
          isDay: hour.isDay,
          condition: hour.condition.text,
          chanceOfRain: hour.chanceOfRain,
          chanceOfSnow: hour.chanceOfSnow))
      }
    }

    return hourForecast
  }

  func createDayForecast() -> Days {
    return Array(forecast.days.dropFirst()).map {
      Day(
        date: $0.date,
        temperatureCelsiusAverage: $0.details.temperatureCelsiusAverage,
        temperatureCelsiusLow: $0.details.temperatureCelsiusLow,
        temperatureCelsiusHigh: $0.details.temperatureCelsiusHigh,
        condition: $0.details.condition.text,
        chanceOfRain: $0.details.chanceOfRain,
        chanceOfSnow: $0.details.chanceOfSnow,
        precipitationMillimeterTotal: $0.details.precipitationMillimeterTotal,
        snowCentimeterTotal: $0.details.snowCentimeterTotal)
    }
  }
}
