//
//  WeatherAPIWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/17/25 at 6:12 PM.
//

import Foundation
/// The model produced by decoding 'WeatherAPI.com' JSON response, used as an intermediate object
struct WeatherAPIWeather: Weather {
  let location: Location
  let current: Current
  let forecast: Forecast
}

// MARK: - Primary components
extension WeatherAPIWeather {
  struct Location: Decodable {
    let name: String
    let time: Date

    enum CodingKeys: String, CodingKey {
      case name
      case time = "localtime"
    }
  }


  struct Current: Decodable {
    let isDay: Int
    let condition: Condition
    let temperatureCelsius: Double
    let feelsLikeCelsius: Double
    let precipitationMillimeter: Double
    let humidity: Int
    let WindDirection: String
    let windKilometersPerHour: Double
    let gustKilometersPerHour: Double

    enum CodingKeys: String, CodingKey {
      case isDay = "is_day"
      case condition
      case temperatureCelsius = "temp_c"
      case feelsLikeCelsius = "feelslike_c"
      case precipitationMillimeter = "precip_mm"
      case humidity = "humidity"
      case WindDirection = "wind_dir"
      case windKilometersPerHour = "wind_kph"
      case gustKilometersPerHour = "gust_kph"
    }
  }


  struct Forecast: Decodable {
    let days: ForecastDays

    enum CodingKeys: String, CodingKey {
      case days = "forecastday"
    }
  }
}

// MARK: - Supporting components
extension WeatherAPIWeather {
  struct Condition: Decodable {
    let text: String
  }


  typealias ForecastDays = [ForecastDay]
  struct ForecastDay: Decodable {
    let date: Date
    let day: Day
    let hours: Hours

    enum CodingKeys: String, CodingKey {
      case date
      case day = "day"
      case hours = "hour"
    }
  }


  struct Day: Decodable {
    let condition: Condition
    let temperatureCelsiusAverage: Double
    let temperatureCelsiusLow: Double
    let temperatureCelsiusHigh: Double
    let chanceOfRain: Int
    let chanceOfSnow: Int
    let precipitationMillimeterTotal: Double
    let snowCentimeterTotal: Double

    enum CodingKeys: String, CodingKey {
      case condition
      case temperatureCelsiusAverage = "avgtemp_c"
      case temperatureCelsiusLow = "mintemp_c"
      case temperatureCelsiusHigh = "maxtemp_c"
      case chanceOfRain = "daily_chance_of_rain"
      case chanceOfSnow = "daily_chance_of_snow"
      case precipitationMillimeterTotal = "totalprecip_mm"
      case snowCentimeterTotal = "totalsnow_cm"
    }
  }


  typealias Hours = [Hour]
  struct Hour: Decodable {
    let time: Date
    let isDay: Int
    let condition: Condition
    let temperatureCelsius: Double
    let chanceOfRain: Int
    let chanceOfSnow: Int
    let precipitationMillimeter: Double
    let snowCentimeter: Double
    let WindDirection: String
    let windKilometersPerHour: Double
    let gustKilometersPerHour: Double


    enum CodingKeys: String, CodingKey {
      case time
      case isDay = "is_day"
      case condition
      case temperatureCelsius = "temp_c"
      case chanceOfRain = "chance_of_rain"
      case chanceOfSnow = "chance_of_snow"
      case precipitationMillimeter = "precip_mm"
      case snowCentimeter = "snow_cm"
      case WindDirection = "wind_dir"
      case windKilometersPerHour = "wind_kph"
      case gustKilometersPerHour = "gust_kph"
    }
  }
}

// MARK: - Custom JSONDecoder
extension WeatherAPIWeather {
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
