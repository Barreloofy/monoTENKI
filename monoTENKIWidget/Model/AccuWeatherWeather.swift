//
// AccuWeatherWeather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 12:51 PM
//

import Foundation

struct AccuWeatherLocation: Decodable {
  let key: String
}


struct AccuWeatherCurrent: Decodable {
  let weatherText: String
  let isDayTime: Bool
  let temperature: Temperature

  struct Temperature: Decodable {
    let metric: Metric

    struct Metric: Decodable {
      let value: Double
    }
  }
}


struct AccuWeatherHour: Decodable {
  let precipitationProbability: Int
}
