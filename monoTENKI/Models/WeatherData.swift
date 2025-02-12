//
//  WeatherData.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/2/25 at 7:07 PM.
//

import Foundation
import SwiftUI
import OSLog

fileprivate let logger = Logger(subsystem: "com.monoTENKI.WeatherData", category: "Error")
@MainActor
final class WeatherData: ObservableObject {
    @Published var currentWeather: CurrentWeather
    @Published var hourForecast: [Hour]
    @Published var dayForecast: [FutureDay]
    @AppStorage("location") var currentLocation = ""
    
    init() {
        currentWeather = CurrentWeather()
        hourForecast = []
        dayForecast = []
    }
    
    func fetchWeather(_ completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard !currentLocation.isEmpty else { return }
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
                    day: weatherData.forecast.today,
                    details: weatherData.current.weatherDetails
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
                
                self.currentWeather = currentWeather
                self.hourForecast = hourForecast
                self.dayForecast = dayForecast
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(error))
                logger.error("\(error)")
            }
        }
    }
}
