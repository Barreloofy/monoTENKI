//
//  AccuWeatherCompound.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/29/25.
//

import Foundation

struct AccuWeatherComposite: Weather {
  let location: String
  let current: [AccuWeatherCurrent]
  let hourForecast: [AccuWeatherHourForecast]
  let dayForecast: AccuWeatherDayForecast
}


extension AccuWeatherComposite {
  func createCurrentWeather() -> CurrentWeather {
    let current = current.first!

    let temperatures = CurrentWeather.Temperatures(
      temperatureCelsius: current.temperature.metric.value,
      temperatureCelsiusLow: current.temperatureSummary.past24HourRange.minimum.metric.value,
      temperatureCelsiusHigh: current.temperatureSummary.past24HourRange.maximum.metric.value,
      feelsLikeCelsius: current.realFeelTemperature.metric.value,
      humidity: current.relativeHumidity,)

    let type = current.precipitationType ?? "--"
    let precipitation = CurrentWeather.Precipitation(
      chance: hourForecast.first!.precipitationProbability,
      rateMillimeter: current.precipitationSummary.precipitation.metric.value,
      totalMillimeter: current.precipitationSummary.past24Hours.metric.value,
      type: type,)

    let wind = CurrentWeather.Wind(
      direction: current.wind.direction.english,
      speedKilometersPerHour: current.wind.speed.metric.value,
      gustKilometersPerHour: current.windGust.speed.metric.value,)

    return CurrentWeather(
      location: location,
      isDay: current.isDayTime,
      condition: current.weatherText,
      temperatures: temperatures,
      precipitation: precipitation,
      wind: wind,)
  }

  func createHourForecast() -> Hours {
    hourForecast.map { hour in
      Hour(
        time: hour.dateTime,
        isDay: hour.isDaylight,
        condition: hour.iconPhrase,
        temperatureCelsius: hour.temperature.value,
        precipitationChance: hour.precipitationProbability,
        precipitationRateMillimeter: hour.totalLiquid.value,
        precipitationType: hour.precipitationType ?? "--",)
    }
  }

  func createDayForecast() -> Days {
    Array(
      dayForecast.dailyForecasts.dropFirst().map { forecast in
        let average = (forecast.temperature.maximum.value + forecast.temperature.minimum.value) / 2
        let type = forecast.day.precipitationType ?? forecast.night.precipitationType ?? "--"
        let chance = forecast.day.precipitationProbability + forecast.night.precipitationProbability
        let total = forecast.day.totalLiquid.value + forecast.night.totalLiquid.value

        return Day(
          date: forecast.date,
          condition: forecast.day.iconPhrase,
          temperatureCelsiusAverage: average,
          temperatureCelsiusLow: forecast.temperature.minimum.value,
          temperatureCelsiusHigh: forecast.temperature.maximum.value,
          precipitationChance: chance,
          precipitationTotalMillimeter: total,
          precipitationType: type,)
      })
  }
}


extension AccuWeatherComposite {
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromPascalCase
    decoder.dateDecodingStrategy = .iso8601UTC

    return decoder
  }
}
