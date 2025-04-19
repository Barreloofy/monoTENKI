//
//  AccuWeatherWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/16/25 at 11:29 AM.
//

import Foundation
/// The composite model for 'AccuWeather' JSON response to allow implementation of 'Weather' protocol
struct AccuWeatherComposite: Weather {
  let location: String
  let current: [AccuWeatherWeatherCurrent]
  let forecastHours: [AccuWeatherWeatherHourForecast]
  let forecastDays: AccuWeatherWeatherDayForecast
}

// MARK: - Generic components used for JSON decoding
extension AccuWeatherComposite {
  struct Metric: Decodable {
    let metric: Value

    enum CodingKeys: String, CodingKey {
      case metric = "Metric"
    }
  }


  struct Value: Decodable {
    let value: Double

    enum CodingKeys: String, CodingKey {
      case value = "Value"
    }
  }
}

// MARK: - Custom JSON decoder
extension AccuWeatherComposite {
  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()

    decoder.dateDecodingStrategy = .iso8601

    return decoder
  }
}

/// The model produced by decoding 'AccuWeather/current' JSON response, used as an intermediate object
struct AccuWeatherWeatherCurrent: Decodable {
  let condition: String
  let isDay: Bool
  let temperatureCelsius: AccuWeatherComposite.Metric
  let feelsLikeCelsius: AccuWeatherComposite.Metric
  let temperatureSummary: TemperatureSummary
  let humidity: Int
  let precipitationSummary: PrecipitationSummary
  let precipitationType: String?
  let wind: Wind
  let windGustKilometersPerHour: WindGust

  enum CodingKeys: String, CodingKey {
    case condition = "WeatherText"
    case isDay = "IsDayTime"
    case temperatureCelsius = "Temperature"
    case feelsLikeCelsius = "RealFeelTemperature"
    case temperatureSummary = "TemperatureSummary"
    case humidity = "RelativeHumidity"
    case precipitationSummary = "PrecipitationSummary"
    case precipitationType = "PrecipitationType"
    case wind = "Wind"
    case windGustKilometersPerHour = "WindGust"
  }
}

// MARK: - AccuWeatherWeatherCurrent components
extension AccuWeatherWeatherCurrent {
  struct Wind: Decodable {
    let direction: Direction
    let speedKilometersPerHour: AccuWeatherComposite.Metric

    enum CodingKeys: String, CodingKey {
      case direction = "Direction"
      case speedKilometersPerHour = "Speed"
    }

    struct Direction: Decodable {
      let text: String

      enum CodingKeys: String, CodingKey {
        case text = "English"
      }
    }
  }


  struct WindGust: Decodable {
    let speed: AccuWeatherComposite.Metric

    enum CodingKeys: String, CodingKey {
      case speed = "Speed"
    }
  }


  struct PrecipitationSummary: Decodable {
    let rate: AccuWeatherComposite.Metric
    let totalMillimeter: AccuWeatherComposite.Metric

    enum CodingKeys: String, CodingKey {
      case rate = "Precipitation"
      case totalMillimeter = "Past24Hours"
    }
  }


  struct TemperatureSummary: Decodable {
    let past24Hour: Temperatures

    enum CodingKeys: String, CodingKey {
      case past24Hour = "Past24HourRange"
    }

    struct Temperatures: Decodable {
      let celsiusLow: AccuWeatherComposite.Metric
      let celsiusHigh: AccuWeatherComposite.Metric

      enum CodingKeys: String, CodingKey {
        case celsiusLow = "Minimum"
        case celsiusHigh = "Maximum"
      }
    }
  }
}

/// The model produced by decoding 'AccuWeather/forecasts/hourly' JSON response, used as an intermediate object
struct AccuWeatherWeatherHourForecast: Decodable {
  let time: Date
  let condition: String
  let isDay: Bool
  let temperatureCelsius: AccuWeatherComposite.Value
  let precipitationChance: Int
  let precipitationType: String?

  enum CodingKeys: String, CodingKey {
    case time = "DateTime"
    case condition = "IconPhrase"
    case isDay = "IsDaylight"
    case temperatureCelsius = "Temperature"
    case precipitationChance = "PrecipitationProbability"
    case precipitationType = "PrecipitationType"
  }
}

/// The model produced by decoding 'AccuWeather/forecasts/daily' JSON response, used as an intermediate object
struct AccuWeatherWeatherDayForecast: Decodable {
  let days: Days

  enum CodingKeys: String, CodingKey {
    case days = "DailyForecasts"
  }
}

// MARK: - AccuWeatherWeatherDayForecast components
extension AccuWeatherWeatherDayForecast {
  typealias Days = [Day]
  struct Day: Decodable {
    let date: Date
    let temperatures: Temperatures
    let details: DetailsDay

    enum CodingKeys: String, CodingKey {
      case date = "Date"
      case temperatures = "Temperature"
      case details = "Day"
    }
  }


  struct Temperatures: Decodable {
    let celsiusLow: AccuWeatherComposite.Value
    let celsiusHigh: AccuWeatherComposite.Value

    enum CodingKeys: String, CodingKey {
      case celsiusLow = "Minimum"
      case celsiusHigh = "Maximum"
    }
  }


  struct DetailsDay: Decodable {
    let condition: String
    let precipitationChance: Int
    let precipitationTotal: AccuWeatherComposite.Value
    let precipitationType: String?

    enum CodingKeys: String, CodingKey {
      case condition = "IconPhrase"
      case precipitationChance = "PrecipitationProbability"
      case precipitationTotal = "TotalLiquid"
      case precipitationType = "PrecipitationType"
    }
  }
}
