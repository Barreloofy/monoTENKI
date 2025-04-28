//
//  AccuWeather+Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/17/25 at 12:25 PM.
//

import Foundation
// MARK: - Implement 'Weather' protocol conformes
extension AccuWeatherComposite {
  func createCurrentWeather() -> CurrentWeather {
    let current = current.first!

    let temperatures = CurrentWeather.Temperatures(
      temperatureCelsius: current.temperatureCelsius.metric.value,
      temperatureCelsiusLow: current.temperatureSummary.past24Hour.celsiusLow.metric.value,
      temperatureCelsiusHigh: current.temperatureSummary.past24Hour.celsiusHigh.metric.value,
      feelsLikeCelsius: current.feelsLikeCelsius.metric.value,
      humidity: current.humidity)

    let type = current.precipitationType ?? "--"
    let precipitation = CurrentWeather.Precipitation(
      rateMillimeter: current.precipitationSummary.rate.metric.value,
      chance: forecastHours.first!.precipitationChance,
      totalMillimeter: current.precipitationSummary.totalMillimeter.metric.value,
      type: type)

    let wind = CurrentWeather.Wind(
      direction: current.wind.direction.text,
      speedKilometersPerHour: current.wind.speedKilometersPerHour.metric.value,
      gustKilometersPerHour: current.windGustKilometersPerHour.speed.metric.value)

    return CurrentWeather(
      location: location,
      isDay: current.isDay,
      condition: current.condition,
      temperatures: temperatures,
      precipitation: precipitation,
      wind: wind)
  }
  
  func createHourForecast() -> Hours {
    forecastHours.map { hour in
      Hour(
        time: hour.time,
        isDay: hour.isDay,
        condition: hour.condition,
        temperatureCelsius: hour.temperatureCelsius.value,
        precipitationChance: 0,
        precipitationRateMillimeter: 0,
        precipitationType: "")
    }
  }
  
  func createDayForecast() -> Days {
    Array(
      forecastDays.days.dropFirst().map { day in
        let avg = (day.temperatures.celsiusHigh.value + day.temperatures.celsiusLow.value) / 2
        let type = day.details.precipitationType ?? "--"

        return Day(
          date: day.date,
          condition: day.details.condition,
          temperatureCelsiusAverage: avg,
          temperatureCelsiusLow: day.temperatures.celsiusLow.value,
          temperatureCelsiusHigh: day.temperatures.celsiusHigh.value,
          precipitationChance: day.details.precipitationChance,
          precipitationTotalMillimeter: day.details.precipitationTotal.value,
          precipitationType: type)
      })
  }
}
