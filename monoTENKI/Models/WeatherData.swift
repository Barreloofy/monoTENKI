//
//  WeatherData.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 7:07 PM.
//

import Foundation

@MainActor
final class WeatherData: ObservableObject {
  private let locationManager: LocationManager
  @Published var currentWeather: CurrentWeather
  @Published var hourForecast: [Hour]
  @Published var dayForecast: [FutureDay]
  @Published var currentLocation: String {
    didSet {
      UserDefaults.standard.set(currentLocation, forKey: "location")
    }
  }

  init() {
    locationManager = LocationManager.shared
    currentWeather = CurrentWeather()
    hourForecast = []
    dayForecast = []
    currentLocation = UserDefaults.standard.string(forKey: "location") ?? ""
  }

  func fetchWeather() async throws {
    guard !currentLocation.isEmpty else { return }

    var currentWeather: CurrentWeather
    var hourForecast = [Hour]()
    var dayForecast = [FutureDay]()

    let weatherData = try await APIClient.fetch(
      service: .weather,
      forType: Weather.self,
      query: currentLocation
    )

    currentWeather = CurrentWeather(
      location: weatherData.location,
      info: weatherData.current,
      day: weatherData.forecast.today)

    let localTime = weatherData.location.time
    let twelveHoursInSeconds = Double(43200)
    let timeIn12Hours = localTime.addingTimeInterval(twelveHoursInSeconds)

    for forecast in weatherData.forecast.forecastDays {
      if forecast.date != weatherData.forecast.forecastDays.first?.date {
        dayForecast.append(FutureDay(
          date: forecast.date,
          maxtempC: forecast.day.maxtempC,
          mintempC: forecast.day.mintempC,
          avgtempC: forecast.day.avgtempC,
          condition: forecast.day.condition.text
        ))
      }

      for hour in forecast.hours {
        guard hourForecast.count < 12 else { break }

        if hour.time > localTime && hour.time < timeIn12Hours { hourForecast.append(hour) }
      }
    }

    self.currentWeather = currentWeather
    self.hourForecast = hourForecast
    self.dayForecast = dayForecast
  }

  func setWeatherToCurrentLocation() async throws {
    let query = locationManager.stringLocation

    guard let firstLocation = try await APIClient.fetch(
      service: .location,
      forType: [Location].self,
      query: query).first else {
      throw LocationError.unavailableLocation
    }

    currentLocation = firstLocation.name
    locationManager.trackLocation = true
  }
}
