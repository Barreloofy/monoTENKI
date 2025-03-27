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
    let temperatures: Temperatures
    let windDetails: WindDetails
    let miscellaneous: Miscellaneous

    init(
      location: String = "",
      condition: String = "",
      temperatures: Temperatures = Temperatures(),
      windDetails: WindDetails = WindDetails(),
      miscellaneous: Miscellaneous = Miscellaneous()) {
      self.location = location
      self.condition = condition
      self.temperatures = temperatures
      self.windDetails = windDetails
      self.miscellaneous = miscellaneous
    }
  }
}


// MARK: - Components
extension WeatherModel.CurrentWeather {
  struct Temperatures {
    let temperatureCelsius: Double
    let temperatureCelsiusLow: Double
    let temperatureCelsiusHigh: Double
    let windChillCelsius: Double

    init(
      temperatureCelsius: Double = 0.0,
      temperatureCelsiusLow: Double = 0.0,
      temperatureCelsiusHigh: Double = 0.0,
      windChillCelsius: Double = 0.0) {
      self.temperatureCelsius = temperatureCelsius
      self.temperatureCelsiusLow = temperatureCelsiusLow
      self.temperatureCelsiusHigh = temperatureCelsiusHigh
      self.windChillCelsius = windChillCelsius
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
}
