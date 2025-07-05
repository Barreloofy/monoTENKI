//
//  AccuWeather+Weather.swift
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
  func createCurrentWeather() throws -> CurrentWeather {
    guard
      let current = current.first,
      let day = dayForecast.dailyForecasts.first,
      let hour = hourForecast.first
    else {
      throw DecodingError.valueNotFound(
        (any Sequence).self,
        .init(codingPath: [], debugDescription: "Nil found while accessing element"))
    }

    let total = day.day.totalLiquid.value + day.night.totalLiquid.value
    let type = current.precipitationType ?? "--"

    let temperatures = CurrentWeather.Temperatures(
      celsius: current.temperature.metric.value,
      celsiusLow: day.temperature.minimum.value,
      celsiusHigh: day.temperature.maximum.value,
      feelsLikeCelsius: current.realFeelTemperature.metric.value,
      humidity: current.relativeHumidity)

    let precipitation = CurrentWeather.Precipitation(
      chance: hour.precipitationProbability,
      rateMillimeter: hour.totalLiquid.value,
      totalMillimeter: total,
      type: type)

    let wind = CurrentWeather.Wind(
      direction: current.wind.direction.english,
      speedKilometersPerHour: current.wind.speed.metric.value,
      gustKilometersPerHour: current.windGust.speed.metric.value)

    return CurrentWeather(
      location: location,
      isDay: current.isDayTime,
      condition: current.weatherText,
      temperatures: temperatures,
      precipitation: precipitation,
      wind: wind)
  }

  func createHourForecast() -> Hours {
    hourForecast.map { hour in
      let type = hour.precipitationType ?? "--"

      let precipitation = Hour.Precipitation(
        chance: hour.precipitationProbability,
        rateMillimeter: hour.totalLiquid.value,
        type: type)

      let wind = Hour.Wind(
        direction: hour.wind.direction.english,
        speedKilometersPerHour: hour.wind.speed.value,
        gustKilometersPerHour: hour.windGust.speed.value)

      return Hour(
        time: hour.dateTime,
        isDay: hour.isDaylight,
        condition: hour.iconPhrase,
        temperatureCelsius: hour.temperature.value,
        precipitation: precipitation,
        wind: wind)
    }
  }

  func createDayForecast() -> Days {
    Array(
      dayForecast.dailyForecasts.dropFirst().map { forecast in
        let average = (forecast.temperature.maximum.value + forecast.temperature.minimum.value) / 2
        
        let type = forecast.day.precipitationType ?? forecast.night.precipitationType ?? "--"
        let chance = (forecast.day.precipitationProbability + forecast.night.precipitationProbability) / 2
        let total = forecast.day.totalLiquid.value + forecast.night.totalLiquid.value

        let temperatures = Day.Temperatures(
          celsiusAverage: average,
          celsiusLow: forecast.temperature.minimum.value,
          celsiusHigh: forecast.temperature.maximum.value)

        let precipitation = Day.Precipitation(
          chance: chance,
          totalMillimeter: total,
          type: type)

        return Day(
          date: forecast.date,
          condition: forecast.day.iconPhrase,
          temperatures: temperatures,
          precipitation: precipitation)
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
