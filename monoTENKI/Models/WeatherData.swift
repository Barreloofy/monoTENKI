//
//  WeatherData.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 7:07 PM.
//

import Foundation

@MainActor
final class WeatherData: ObservableObject {
    @Published var currentWeather: CurrentWeather
    @Published var hourForecast: [Hour]
    @Published var dayForecast: [Day]
    
    init() {
        currentWeather = CurrentWeather()
        hourForecast = []
        dayForecast = []
    }
    
    func fetchWeather(_ query: String) {
        Task {
            let weatherData = try await APIClient.fetch(service: .weather, forType: Weather.self, query)
            currentWeather = CurrentWeather(location: weatherData.location.name, info: weatherData.current)
            hourForecast = weatherData.forecast.forecastDays.first?.hours ?? []
            weatherData.forecast.forecastDays.forEach {
                dayForecast.append($0.day)
            }
        }
    }
}
