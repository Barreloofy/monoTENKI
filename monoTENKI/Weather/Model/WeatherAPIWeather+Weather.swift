//
//  WeatherAPIWeather+Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/30/25.
//

import Foundation

extension WeatherAPIWeather {
  func determinePrecipitation(chanceOfRain: Int, chanceOfSnow: Int) -> (chance: Int, type: String) {
    if (chanceOfRain + chanceOfSnow) == 0 {
      (0, "--")
    } else {
      if chanceOfRain > chanceOfSnow {
        (chanceOfRain, "Rain")
      } else if chanceOfRain < chanceOfSnow {
        (chanceOfSnow, "Snow")
      } else {
        (chanceOfRain, "Mixed")
      }
    }
  }
}


extension WeatherAPIWeather {
  func createCurrentWeather() -> CurrentWeather {
    let day = forecast.forecastday.first!.day

    var calendar = Calendar.current
    calendar.timeZone = TimeZone(abbreviation: "UTC")!
    let hour = forecast.forecastday.first!.hour.filter { forecast in
      let localTimeHour = calendar.component(.hour, from: location.localtime)
      let hourComponent = calendar.component(.hour, from: forecast.time)

      return localTimeHour == hourComponent
    }.first!

    let isDay = current.isDay == 1 ? true : false

    let temperatures = CurrentWeather.Temperatures(
      temperatureCelsius: current.tempC,
      temperatureCelsiusLow: day.mintempC,
      temperatureCelsiusHigh: day.maxtempC,
      feelsLikeCelsius: current.feelslikeC,
      humidity: current.humidity,)

    let wind = CurrentWeather.Wind(
      direction: current.windDir,
      speedKilometersPerHour: current.windKph,
      gustKilometersPerHour: current.gustKph,)

    let (chance, type) = determinePrecipitation(
      chanceOfRain: hour.chanceOfRain,
      chanceOfSnow: hour.chanceOfSnow,)
    let rate = current.precipMm
    let totalSnowMillimeter = day.totalsnowCm * 10
    let total = day.totalprecipMm + totalSnowMillimeter

    let precipitation = CurrentWeather.Precipitation(
      chance: chance,
      rateMillimeter: rate,
      totalMillimeter: total,
      type: type,)

    return CurrentWeather(
      location: location.name,
      isDay: isDay,
      condition: current.condition.text,
      temperatures: temperatures,
      precipitation: precipitation,
      wind: wind,)
  }

  func createHourForecast() -> Hours {
    let twelveHoursInSeconds: TimeInterval = 43_200
    var hourForecast: Hours = []
    hourForecast.reserveCapacity(12)

    for day in forecast.forecastday {
      for hour in day.hour {
        guard hourForecast.count < 12 else { return hourForecast }

        guard hour.time > location.localtime &&
              hour.time <= location.localtime.addingTimeInterval(twelveHoursInSeconds)
        else { continue }

        let isDay = hour.isDay == 1 ? true : false

        let (chance, type) = determinePrecipitation(
          chanceOfRain: hour.chanceOfRain,
          chanceOfSnow: hour.chanceOfSnow,)
        let snowMillimeter = hour.snowCm * 10
        let rate = hour.precipMm + snowMillimeter

        hourForecast.append(
          Hour(
            time: hour.time,
            isDay: isDay,
            condition: hour.condition.text,
            temperatureCelsius: hour.tempC,
            precipitationChance: chance,
            precipitationRateMillimeter: rate,
            precipitationType: type,))
      }
    }

    return hourForecast
  }

  func createDayForecast() -> Days {
    Array(
      forecast.forecastday.dropFirst().map { forecast in
        let day = forecast.day

        let (chance, type) = determinePrecipitation(
          chanceOfRain: day.dailyChanceOfRain,
          chanceOfSnow: day.dailyChanceOfSnow,)
        let totalSnowMillimeter = day.totalsnowCm * 10
        let total = day.totalprecipMm + totalSnowMillimeter

        return Day(
          date: forecast.date,
          condition: day.condition.text,
          temperatureCelsiusAverage: day.avgtempC,
          temperatureCelsiusLow: day.mintempC,
          temperatureCelsiusHigh: day.maxtempC,
          precipitationChance: chance,
          precipitationTotalMillimeter: total,
          precipitationType: type,)
      }
    )
  }
}
