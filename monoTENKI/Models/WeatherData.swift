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
    @AppStorage("location") var currentLocation = "Saint Petersburg"
    private(set) var isDay: Bool
    
    init() {
        currentWeather = CurrentWeather()
        hourForecast = []
        dayForecast = []
        isDay = true
    }
    
    func fetchWeather() {
        Task {
            do {
                var currentWeather: CurrentWeather
                var hourForecast = [Hour]()
                var dayForecast = [Day]()
                
                let weatherData = try await APIClient.fetch(service: .weather, forType: Weather.self, currentLocation)
                currentWeather = CurrentWeather(
                    location: weatherData.location.name,
                    tempC: weatherData.current.tempC,
                    condition: weatherData.current.conditionText,
                    day: weatherData.forecast.today
                )
                
                let time = weatherData.location.time!
                let timeIn12H = time.addingTimeInterval(43200)
                for forecast in weatherData.forecast.forecastDays {
                    if forecast.id != weatherData.forecast.forecastDays.first?.id {
                        dayForecast.append(forecast.day)
                    }
                    for hour in forecast.hours {
                        guard hourForecast.count < 12 else { break }
                        if hour.date > time && hour.date < timeIn12H {
                            hourForecast.append(hour)
                        }
                    }
                }
                
                let currentHour = Calendar.current.component(.hour, from: time)
                self.isDay = currentHour >= 6 && currentHour < 18
                self.currentWeather = currentWeather
                self.hourForecast = hourForecast
                self.dayForecast = dayForecast
            } catch {
                print(error)
            }
        }
    }
}
