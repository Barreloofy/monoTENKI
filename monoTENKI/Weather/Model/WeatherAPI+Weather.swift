//
//  WeatherAPI+Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/30/25.
//

import Foundation

extension WeatherAPIWeather {
  func createCurrentWeather() throws -> CurrentWeather {
    guard let today = forecast.forecastday.first else {
      throw DecodingError.valueNotFound(
        Forecast.ForecastDays.self,
        .init(codingPath: [], debugDescription: "Nil found 'forecast.forecastday.first'"))
    }

    let day = today.day

    guard let hour = today.hour.first(where: { $0.time.compareDateComponent(.hour, with: location.localtime) }) else {
      throw DecodingError.valueNotFound(
        Forecast.ForecastDay.Hour.self,
        .init(codingPath: [], debugDescription: "Nil found 'forecast.forecastday.first.hour.first'"))
    }

    let isDay = current.isDay == 1 ? true : false

    let chance = determinePrecipitationChance(hour.chanceOfRain, hour.chanceOfSnow)
    let type = determinePrecipitationType(hour.precipMm, hour.snowCm)
    let rate = current.precipMm
    let totalSnowMillimeter = day.totalsnowCm * 10
    let total = day.totalprecipMm + totalSnowMillimeter

    let temperatures = CurrentWeather.Temperatures(
      celsius: current.tempC,
      celsiusLow: day.mintempC,
      celsiusHigh: day.maxtempC,
      feelsLikeCelsius: current.feelslikeC,
      humidity: current.humidity)

    let wind = CurrentWeather.Wind(
      direction: current.windDir,
      speedKilometersPerHour: current.windKph,
      gustKilometersPerHour: current.gustKph)

    let precipitation = CurrentWeather.Precipitation(
      chance: chance,
      rateMillimeter: rate,
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

  func createHourForecast() -> Hours {
    let twelveHoursInSeconds: TimeInterval = 43_200

    var hourForecast: Hours = []
    hourForecast.reserveCapacity(12)

    for day in forecast.forecastday {
      for hour in day.hour {
        guard hourForecast.count < 12 else { return hourForecast }

        guard
          hour.time > location.localtime &&
          hour.time <= location.localtime.addingTimeInterval(twelveHoursInSeconds)
        else { continue }

        let isDay = hour.isDay == 1 ? true : false

        let chance = determinePrecipitationChance(hour.chanceOfRain, hour.chanceOfSnow)
        let type = determinePrecipitationType(hour.precipMm, hour.snowCm)
        let snowMillimeter = hour.snowCm * 10
        let rate = hour.precipMm + snowMillimeter

        let precipitation = Hour.Precipitation(
          chance: chance,
          rateMillimeter: rate,
          type: type)

        let wind = Hour.Wind(
          direction: hour.windDir,
          speedKilometersPerHour: hour.windKph,
          gustKilometersPerHour: hour.gustKph)

        hourForecast.append(
          Hour(
            time: hour.time,
            isDay: isDay,
            condition: hour.condition.text,
            temperatureCelsius: hour.tempC,
            precipitation: precipitation,
            wind: wind))
      }
    }

    return hourForecast
  }

  func createDayForecast() -> Days {
    Array(
      forecast.forecastday.dropFirst().map { forecast in
        let day = forecast.day

        let chance = determinePrecipitationChance(day.dailyChanceOfRain, day.dailyChanceOfSnow)
        let type = determinePrecipitationType(day.totalprecipMm, day.totalsnowCm)
        let totalSnowMillimeter = day.totalsnowCm * 10
        let total = day.totalprecipMm + totalSnowMillimeter

        let temperatures = Day.Temperatures(
          celsiusAverage: day.avgtempC,
          celsiusLow: day.mintempC,
          celsiusHigh: day.maxtempC)

        let precipitation = Day.Precipitation(
          chance: chance,
          totalMillimeter: total,
          type: type)

        return Day(
          date: forecast.date,
          condition: day.condition.text,
          temperatures: temperatures,
          precipitation: precipitation)
      })
  }
}


extension WeatherAPIWeather {
  func determinePrecipitationType(_ rain: Double, _ snow: Double) -> String {
    guard rain + snow > 0 else { return "--" }

    let snow = snow * 10

    return rain > snow ? "Rain" : rain == snow ? "Mixed" : "Snow"
  }

  func determinePrecipitationChance(_ rain: Int, _ snow: Int) -> Int {
    rain > snow ? rain : snow
  }
}


extension WeatherAPIWeather {
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .weatherAPIDateStrategy

    return decoder
  }
}
