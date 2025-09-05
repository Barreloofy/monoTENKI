//
//  AccuWeatherWeather.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/29/25.
//

import Foundation

struct AccuWeatherMetric: Decodable {
  let metric: AccuWeatherValue
}


struct AccuWeatherValue: Decodable {
  let value: Double
}


struct AccuWeatherCurrent: Decodable {
  let isDayTime: Bool
  let weatherText: String
  let temperature: AccuWeatherMetric
  let realFeelTemperature: AccuWeatherMetric
  let relativeHumidity: Int
  let precipitationType: String?
  let precip1hr: AccuWeatherMetric
  let wind: Wind
  let windGust: WindGust

  struct Wind: Decodable {
    let direction: Direction
    let speed: AccuWeatherMetric

    struct Direction: Decodable {
      let english: String
    }
  }

  struct WindGust: Decodable {
    let speed: AccuWeatherMetric
  }
}


struct AccuWeatherHourForecast: Decodable {
  let dateTime: Date
  let isDaylight: Bool
  let iconPhrase: String
  let temperature: AccuWeatherValue
  let precipitationProbability: Int
  let totalLiquid: AccuWeatherValue
  let precipitationType: String?
  let wind: Wind
  let windGust: WindGust

  struct Wind: Decodable {
    let direction: Direction
    let speed: AccuWeatherValue

    struct Direction: Decodable {
      let english: String
    }
  }

  struct WindGust: Decodable {
    let speed: AccuWeatherValue
  }
}


struct AccuWeatherDayForecast: Decodable {
  let dailyForecasts: DailyForecasts

  typealias DailyForecasts = [DailyForecast]
  struct DailyForecast: Decodable {
    let date: Date
    let temperature: Temperature
    let day: Day
    let night: Night

    struct Temperature: Decodable {
      let minimum: AccuWeatherValue
      let maximum: AccuWeatherValue
    }

    struct Day: Decodable {
      let iconPhrase: String
      let precipitationProbability: Int
      let totalLiquid: AccuWeatherValue
      let precipitationType: String?
    }

    struct Night: Decodable {
      let precipitationProbability: Int
      let totalLiquid: AccuWeatherValue
      let precipitationType: String?
    }
  }
}
