//
//  WeatherStruct.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 5:30 PM.
//

import Foundation

// MARK: - Interal Structs. Used throughout the app for diffrent views
struct CurrentWeather {
    let location: String
    let tempC: Double
    let condition: String
    let day: FutureDay
    let details: CurrentWeatherDetails
    
    init(
        location: String = "",
        tempC: Double = 0.0,
        condition: String = "",
        day: FutureDay = FutureDay(),
        details: CurrentWeatherDetails = CurrentWeatherDetails()
    ) {
        self.location = location
        self.tempC = tempC
        self.condition = condition
        self.day = day
        self.details = details
    }
}


struct CurrentWeatherDetails {
    let windDirection: String
    let windSpeedKph: Double
    let windGustKph: Double
    let windchillC: Double
    let precipitationMm: Double
    let humidity: Int
    
    init(
        windDirection: String = "",
        windSpeedKph: Double = 0.0,
        windGustKph: Double = 0.0,
        windchillC: Double = 0.0,
        precipitationMm: Double = 0.0,
        humidity: Int = 0
    ) {
        self.windDirection = windDirection
        self.windSpeedKph = windSpeedKph
        self.windGustKph = windGustKph
        self.windchillC = windchillC
        self.precipitationMm = precipitationMm
        self.humidity = humidity
    }
}


struct FutureDay: Identifiable {
    let id = UUID()
    let date: Date
    let maxtempC: Double
    let mintempC: Double
    let avgtempC: Double
    let condition: String
    
    init(
        date: Date = Date(),
        maxtempC: Double = 0.0,
        mintempC: Double = 0.0,
        avgtempC: Double = 0.0,
        condition: String = "Clear"
    ) {
        self.date = date
        self.maxtempC = maxtempC
        self.mintempC = mintempC
        self.avgtempC = avgtempC
        self.condition = condition
    }
}

// MARK: - Decodable Structs. Used to decode the API response into Swift Data.
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
    let windchillC: Double
    let condition: Condition
    let windDirection: String
    let windSpeedKph: Double
    let windGustKph: Double
    let precipitationMm: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case tempC, condition, humidity
        case windchillC = "windchillC"
        case windDirection = "windDir"
        case windSpeedKph = "windKph"
        case windGustKph = "gustKph"
        case precipitationMm = "precipMm"
    }
    
    var conditionText: String {
        return condition.text
    }
    
    var weatherDetails: CurrentWeatherDetails {
        return CurrentWeatherDetails(
            windDirection: windDirection,
            windSpeedKph: windSpeedKph,
            windGustKph: windGustKph,
            windchillC: windchillC,
            precipitationMm: precipitationMm,
            humidity: humidity
        )
    }
}


struct Forecast: Decodable {
    let forecastDays: [ForecastDay]
    
    var today: FutureDay {
        return FutureDay(
            date: forecastDays.first!.date,
            maxtempC: forecastDays.first!.day.maxtempC,
            mintempC: forecastDays.first!.day.mintempC,
            avgtempC: forecastDays.first!.day.avgtempC,
            condition: forecastDays.first!.day.condition.text
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case forecastDays = "forecastday"
    }
}


struct ForecastDay: Decodable {
    let date: Date
    let day: Day
    let hours: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case date, day
        case hours = "hour"
    }
}


struct Day: Decodable {
    let maxtempC: Double
    let mintempC: Double
    let avgtempC: Double
    let condition: Condition
}


struct Hour: Decodable {
    let time: Date
    let tempC: Double
    let condition: Condition
    
    var conditionText: String {
        return condition.text
    }
}
