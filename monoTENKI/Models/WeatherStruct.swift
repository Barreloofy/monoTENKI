//
//  WeatherStruct.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:30 PM.
//

import Foundation

struct Condition: Decodable {
    let text: String
}


struct CurrentWeather {
    let location: String
    let tempC: Double
    let condition: String
    
    init(location: String = "", tempC: Double = 0.0, condition: String = "") {
        self.location = location
        self.tempC = tempC
        self.condition = condition
    }
}


struct Weather: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}


struct Current: Decodable {
    let tempC: Double
    let condition: Condition
}


struct Forecast: Decodable {
    let forecastDays: [ForecastDay]
    
    enum CodingKeys: String, CodingKey {
        case forecastDays = "forecastday"
    }
}


struct ForecastDay: Decodable, Identifiable {
    let id = UUID()
    let day: Day
    let hours: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case day
        case hours = "hour"
    }
}


struct Day: Decodable, Identifiable {
    let id = UUID()
    let maxtempC: Double
    let mintempC: Double
    let avgtempC: Double
    let condition: Condition
    
    enum CodingKeys: CodingKey {
        case maxtempC
        case mintempC
        case avgtempC
        case condition
    }
}


struct Hour: Decodable {
    let date: Date
    let tempC: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case date = "time"
        case tempC, condition
    }
}
