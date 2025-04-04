//
//  Weather.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/17/25 at 6:12 PM.
//

import Foundation
/// The model used as the decoded intermediate object for weather data
struct Weather: Decodable {
  let location: Location
  let current: Current
  let forecast: Forecast

  init() {
    location = Location()
    current = Current()
    forecast = Forecast()
  }
}

// MARK: - Primary Weather Components
extension Weather {
  struct Location: Decodable {
    let name: String
    let time: Date

    init() {
      name = ""
      time = Date()
    }

    enum CodingKeys: String, CodingKey {
      case name
      case time = "localtime"
    }
  }


  struct Current: Decodable {
    let temperatureCelsius: Double
    let isDay: Int
    let condition: Condition
    let precipitationMillimeter: Double
    let humidity: Int
    let feelsLikeCelsius: Double
    let WindDirection: String
    let windKilometrePerHour: Double
    let gustKilometrePerHour: Double

    init() {
      self.temperatureCelsius = 0.0
      self.isDay = 1
      self.condition = Condition()
      self.precipitationMillimeter = 0.0
      self.humidity = 0
      self.feelsLikeCelsius = 0.0
      self.WindDirection = ""
      self.windKilometrePerHour = 0.0
      self.gustKilometrePerHour = 0.0
    }

    enum CodingKeys: String, CodingKey {
      case temperatureCelsius = "temp_c"
      case isDay = "is_day"
      case condition
      case precipitationMillimeter = "precip_mm"
      case humidity = "humidity"
      case feelsLikeCelsius = "feelslike_c"
      case WindDirection = "wind_dir"
      case windKilometrePerHour = "wind_kph"
      case gustKilometrePerHour = "gust_kph"
    }
  }


  struct Forecast: Decodable {
    let days: ForecastDays

    init() {
      days = []
    }

    enum CodingKeys: String, CodingKey {
      case days = "forecastday"
    }
  }
}

// MARK: - Supporting Weather Components
extension Weather {
  struct Condition: Decodable {
    let text: String

    init() {
      text = ""
    }
  }

  typealias ForecastDays = [ForecastDay]
  struct ForecastDay: Decodable {
    let date: Date
    let details: DayDetails
    let hours: Hours

    enum CodingKeys: String, CodingKey {
      case date
      case details = "day"
      case hours = "hour"
    }
  }


  struct DayDetails: Decodable {
    let maxTemperatureCelsius: Double
    let minTemperatureCelsius: Double
    let avgTemperatureCelsius: Double
    let precipitationMillimeterTotal: Double
    let snowCentimeterTotal: Double
    let chanceOfRain: Int
    let chanceOfSnow: Int
    let condition: Condition

    init() {
      self.maxTemperatureCelsius = 0.0
      self.minTemperatureCelsius = 0.0
      self.avgTemperatureCelsius = 0.0
      self.precipitationMillimeterTotal = 0.0
      self.snowCentimeterTotal = 0.0
      self.chanceOfRain = 0
      self.chanceOfSnow = 0
      self.condition = Condition()
    }

    enum CodingKeys: String, CodingKey {
      case maxTemperatureCelsius = "maxtemp_c"
      case minTemperatureCelsius = "mintemp_c"
      case avgTemperatureCelsius = "avgtemp_c"
      case precipitationMillimeterTotal = "totalprecip_mm"
      case snowCentimeterTotal = "totalsnow_cm"
      case chanceOfRain = "daily_chance_of_rain"
      case chanceOfSnow = "daily_chance_of_snow"
      case condition
    }
  }


  typealias Hours = [Hour]
  struct Hour: Decodable {
    let time: Date
    let temperatureCelsius: Double
    let isDay: Int
    let condition: Condition
    let chanceOfRain: Int
    let chanceOfSnow: Int

    enum CodingKeys: String, CodingKey {
      case time
      case temperatureCelsius = "temp_c"
      case isDay = "is_day"
      case condition
      case chanceOfRain = "chance_of_rain"
      case chanceOfSnow = "chance_of_snow"
    }
  }
}

// MARK: - Custom JSONDecoder
extension Weather {
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let stringDate = try container.decode(String.self)
      let dateFormatter = DateFormatter()

      dateFormatter.timeZone = TimeZone(identifier: "UTC")
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

      if let date = dateFormatter.date(from: stringDate) { return date }
      dateFormatter.dateFormat = "yyyy-MM-dd"
      if let date = dateFormatter.date(from: stringDate) { return date }

      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Date string does not match format expected by formatter")
    }

    return decoder
  }
}
