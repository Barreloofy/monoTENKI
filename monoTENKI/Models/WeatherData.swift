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
    @Published var dayForecast: [FutureDay]
    @AppStorage("location") var currentLocation = "Saint Petersburg"
    private(set) var isDay: Bool
    
    init() {
        currentWeather = CurrentWeather()
        hourForecast = []
        dayForecast = []
        isDay = true
    }
    
    func fetchWeather(_ completionHandler: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                var currentWeather: CurrentWeather
                var hourForecast = [Hour]()
                var dayForecast = [FutureDay]()
                
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
                    if forecast.date != weatherData.forecast.forecastDays.first?.date {
                        dayForecast.append(
                            FutureDay(
                                date: forecast.date,
                                maxtempC: forecast.day.maxtempC,
                                mintempC: forecast.day.mintempC,
                                avgtempC: forecast.day.avgtempC,
                                condition: forecast.day.condition.text
                            )
                        )
                    }
                    for hour in forecast.hours {
                        guard hourForecast.count < 12 else { break }
                        if hour.time > time && hour.time < timeIn12H {
                            hourForecast.append(hour)
                        }
                    }
                }
                
                let currentHour = Calendar.current.component(.hour, from: time)
                self.isDay = currentHour >= 6 && currentHour < 18
                self.currentWeather = currentWeather
                self.hourForecast = hourForecast
                self.dayForecast = dayForecast
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}
