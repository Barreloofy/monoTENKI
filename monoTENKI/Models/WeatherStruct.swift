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


struct Weather: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}


struct Current: Decodable {
    let tempC: Double
    let tempF: Double
    let condition: Condition
}


struct Forecast: Decodable {
    let forecastDays: [ForecastDay]
    
    enum CodingKeys: String, CodingKey {
        case forecastDays = "forecastday"
    }
}


struct ForecastDay: Decodable {
    let day: Day
    let hours: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case day
        case hours = "hour"
    }
}


struct Day: Decodable {
    let maxtempC: Double
    let maxtempF: Double
    let mintempC: Double
    let mintempF: Double
    let avgtempC: Double
    let avgtempF: Double
    let condition: Condition
}


struct Hour: Decodable {
    let date: Date
    let tempC: Double
    let tempF: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case date = "timeEpoch"
        case tempC, tempF, condition
    }
}