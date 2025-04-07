//
//  WeatherModel.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 3:14 PM.
//

import Foundation
/// Weather aggregate model
@MainActor
@Observable
class WeatherModel {
  var currentWeather: CurrentWeather
  var hourForecast: Weather.Hours
  var dayForecast: Weather.ForecastDays

  init() {
    currentWeather = CurrentWeather()
    hourForecast = []
    dayForecast = []
  }

  func getWeather(for location: String) async throws {
    let httpClient = HTTPClient(
      urlProvider: WeatherAPI.weather(location),
      decoder: Weather.decoder)

    let weather: Weather = try await httpClient.fetch()
    async let currentWeather = createCurrentWeather(from: weather)
    async let hourForecast = createHourForecast(from: weather)
    async let dayForecast = createDayForecast(from: weather)

    self.currentWeather = await currentWeather
    self.hourForecast = await hourForecast
    self.dayForecast = await dayForecast
  }
}

// MARK: - Convert decoded JSON to convenience properties
extension WeatherModel {
  private func createCurrentWeather(from weather: Weather) -> CurrentWeather {
    let details = weather.forecast.days.first!.details

    let temperatures = CurrentWeather.Temperatures(
      temperatureCelsius: weather.current.temperatureCelsius,
      temperatureCelsiusLow: details.minTemperatureCelsius,
      temperatureCelsiusHigh: details.maxTemperatureCelsius,
      feelsLikeCelsius: weather.current.feelsLikeCelsius,
      humidity: weather.current.humidity)

    let windDetails = CurrentWeather.WindDetails(
      windDirection: weather.current.WindDirection,
      windSpeed: weather.current.windKilometrePerHour,
      windGust: weather.current.gustKilometrePerHour)

    let rate: Double
    let chance: Int
    let total: Double
    let type: String

    total = details.precipitationMillimeterTotal + (details.snowCentimeterTotal * 10)
    rate = weather.current.precipitationMillimeter

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
      location: weather.location.name,
      condition: weather.current.condition.text,
      isDay: weather.current.isDay,
      temperatures: temperatures,
      windDetails: windDetails,
      downfall: downfall)
  }

  private func createHourForecast(from weather: Weather) -> Weather.Hours {
    let twelveHoursinSeconds: TimeInterval = 43_200
    var hourForecast: Weather.Hours = []

    for day in weather.forecast.days {
      guard hourForecast.count < 12 else { return hourForecast }

      for hour in day.hours {
        guard hourForecast.count < 12 else { return hourForecast }
        guard hour.time > weather.location.time &&
             hour.time <= weather.location.time.addingTimeInterval(twelveHoursinSeconds)
        else { continue }
        hourForecast.append(hour)
      }
    }

    return hourForecast
  }

  private func createDayForecast(from weather: Weather) -> Weather.ForecastDays {
    return Array(weather.forecast.days.dropFirst())
  }
}
