//
//  WeatherData.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 7:07 PM.
//

import Foundation
import SwiftUI

@MainActor
final class WeatherData: ObservableObject {
    @Published var currentWeather: CurrentWeather
    @Published var hourForecast: [Hour]
    @Published var dayForecast: [Day]
    @AppStorage("location") var currentLocation = ""
    
    init() {
        currentWeather = CurrentWeather()
        hourForecast = []
        dayForecast = []
    }
    
    func fetchWeather(_ query: String) {
        Task {
            do {
                let weatherData = try await APIClient.fetch(service: .weather, forType: Weather.self, query)
                currentWeather = CurrentWeather(location: weatherData.location.name, tempC: weatherData.current.tempC, condition: weatherData.current.condition.text)
                let time = weatherData.location.time
                let timeIn12H = time!.addingTimeInterval(43200)
                for forecast in weatherData.forecast.forecastDays {
                    if forecast.id != weatherData.forecast.forecastDays.first?.id {
                        dayForecast.append(forecast.day)
                    }
                    for hour in forecast.hours {
                        guard hourForecast.count < 12 else { break }
                        if hour.date > time! && hour.date < timeIn12H {
                            hourForecast.append(hour)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
