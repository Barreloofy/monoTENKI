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
    CurrentWeather(
      location: location,
      condition: current.condition,
      isDay: current.isDay ? 1 : 0,
      temperatures: CurrentWeather.Temperatures(
        temperatureCelsius: current.temperatureCelsius.metric.value,
        temperatureCelsiusLow: current.temperatureSummary.past24Hour.celsiusLow.metric.value,
        temperatureCelsiusHigh: current.temperatureSummary.past24Hour.celsiusHigh.metric.value,
        feelsLikeCelsius: current.feelsLikeCelsius.metric.value,
        humidity: current.humidity),
      precipitation: CurrentWeather.Precipitation(
        rateMillimeter: current.precipitationSummary.rate.metric.value,
        chance: forecastHours.first!.precipitationChance,
        totalMillimeter: current.precipitationSummary.totalMillimeter.metric.value,
        type: current.precipitationType ?? "--"),
      wind: CurrentWeather.Wind(
        direction: current.wind.direction.text,
        speedKilometersPerHour: current.wind.speedKilometersPerHour.metric.value,
        gustKilometersPerHour: current.windGustKilometersPerHour.speed.metric.value))
  }
  
  func createHourForecast() -> Hours {
    forecastHours.map {
      Hour(
        time: $0.time,
        isDay: $0.isDay ? 1 : 0,
        condition: $0.condition,
        temperatureCelsius: $0.temperatureCelsius.value)
    }
  }
  
  func createDayForecast() -> Days {
    forecastDays.days.map {
      let avg = ($0.temperatures.celsiusHigh.value + $0.temperatures.celsiusLow.value) / 2

      return Day(
        date: $0.date,
        condition: $0.details.condition,
        temperatureCelsiusAverage: avg,
        temperatureCelsiusLow: $0.temperatures.celsiusLow.value,
        temperatureCelsiusHigh: $0.temperatures.celsiusHigh.value,
        precipitationChance: $0.details.precipitationChance,
        precipitationMillimeterTotal: $0.details.precipitationTotal.value,
        type: $0.details.precipitationType ?? "--")
    }
  }
}
