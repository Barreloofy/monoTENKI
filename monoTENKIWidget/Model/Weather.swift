//
// Weather.swift
// monoTENKI
//
// Created by Barreloofy on 6/19/25 at 1:00 PM
//

protocol CreateWeather: Sendable {
  func create() throws -> Weather
}


struct Weather {
  let condition: String
  let isDay: Bool
  let temperatureCelsius: Double
  let precipitationChance: Int
}
