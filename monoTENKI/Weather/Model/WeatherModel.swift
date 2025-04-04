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
    let temperatures = CurrentWeather.Temperatures(
      temperatureCelsius: weather.current.temperatureCelsius,
      temperatureCelsiusLow: weather.forecast.days.first!.details.minTemperatureCelsius,
      temperatureCelsiusHigh: weather.forecast.days.first!.details.maxTemperatureCelsius,
      feelsLikeCelsius: weather.current.feelsLikeCelsius)

    let windDetails = CurrentWeather.WindDetails(
      windDirection: weather.current.WindDirection,
      windSpeed: weather.current.windKilometrePerHour,
      windGust: weather.current.gustKilometrePerHour)

    let totalDownfall = weather.forecast.days.first!.details.precipitationMillimeterTotal + weather.forecast.days.first!.details.snowCentimeterTotal

    let rate = weather.current.precipitationMillimeter

    let chance: Int

    let type: String

    if weather.forecast.days.first!.details.chanceOfRain > weather.forecast.days.first!.details.chanceOfSnow {
      chance = weather.forecast.days.first!.details.chanceOfRain
      type = "Rain"
    } else {
      chance = weather.forecast.days.first!.details.chanceOfSnow
      type = "Snow"
    }



    let downfall = CurrentWeather.Downfall(
      rate: rate,
      chance: chance,
      total: totalDownfall,
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
