//
//  WeatherModel+CurrentWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/19/25 at 2:32 PM.
//

// MARK: - Compound model used as the 'currentWeather' type
extension WeatherModel {
  struct CurrentWeather {
    let location: String
    let condition: String
    let isDay: Int
    let temperatures: Temperatures
    let windDetails: WindDetails
    let downfall: Downfall

    init(
      location: String = "",
      condition: String = "",
      isDay: Int = 1,
      temperatures: Temperatures = Temperatures(),
      windDetails: WindDetails = WindDetails(),
      downfall: Downfall = Downfall()) {
      self.location = location
      self.condition = condition
      self.isDay = isDay
      self.temperatures = temperatures
      self.windDetails = windDetails
      self.downfall = downfall
    }
  }
}


// MARK: - Components
extension WeatherModel.CurrentWeather {
  struct Temperatures {
    let temperatureCelsius: Double
    let temperatureCelsiusLow: Double
    let temperatureCelsiusHigh: Double
    let feelsLikeCelsius: Double
    let humidity: Int

    init(
      temperatureCelsius: Double = 0.0,
      temperatureCelsiusLow: Double = 0.0,
      temperatureCelsiusHigh: Double = 0.0,
      feelsLikeCelsius: Double = 0.0,
      humidity: Int = 0) {
      self.temperatureCelsius = temperatureCelsius
      self.temperatureCelsiusLow = temperatureCelsiusLow
      self.temperatureCelsiusHigh = temperatureCelsiusHigh
      self.feelsLikeCelsius = feelsLikeCelsius
      self.humidity = humidity
    }
  }


  struct WindDetails {
    let windDirection: String
    let windSpeed: Double
    let windGust: Double

    init(
      windDirection: String = "",
      windSpeed: Double = 0.0,
      windGust: Double = 0.0) {
      self.windDirection = windDirection
      self.windSpeed = windSpeed
      self.windGust = windGust
    }
  }


  struct Miscellaneous {
    let precipitation: Double
    let humidity: Int

    init(
      precipitation: Double = 0.0,
      humidity: Int = 0) {
      self.precipitation = precipitation
      self.humidity = humidity
    }
  }


  struct Downfall {
    let rate: Double
    let chance: Int
    let total: Double
    let type: String

    init(
      rate: Double = 0.0,
      chance: Int = 0,
      total: Double = 0.0,
      type: String = "") {
        self.rate = rate
        self.chance = chance
        self.total = total
        self.type = type
      }
  }
}
