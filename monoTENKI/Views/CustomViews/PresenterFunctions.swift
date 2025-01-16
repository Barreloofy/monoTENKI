//
//  PresenterFunctions.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/5/25 at 8:34 PM.
//

import Foundation

func presentTemperature(_ unit: UnitData.TemperatureUnits, _ tempCDouble: Double) -> String {
    let degreeSymbol = "\u{00B0}"
    if unit == .celsius {
        return String(Int(tempCDouble)) + degreeSymbol
    } else {
        let tempFInt = Int(tempCDouble * (9/5) + 32)
        return String(tempFInt) + degreeSymbol
    }
}

func presentTime(for time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm"
    return dateFormatter.string(from: time)
}

func getWeatherIcon(for condition: String, isDay: Bool) -> String {
    let condition = condition.trimmingCharacters(in: .whitespaces).lowercased()
    switch condition {
        case "sunny", "clear":
            return isDay ? "sun.max.fill" : "moon.fill"
        case "partly cloudy":
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case "cloudy", "overcast":
            return "cloud.fill"
        case "mist", "fog":
            return "cloud.fog.fill"
        case "light drizzle" ,"patchy rain possible", "patchy rain nearby","light rain", "moderate rain at times", "moderate rain", "heavy rain at times", "heavy rain":
            return "cloud.rain.fill"
        case "patchy snow possible", "light snow", "patchy light snow", "patchy moderate snow", "moderate snow", "patchy heavy snow", "heavy snow":
            return "cloud.snow.fill"
        case "patchy sleet possible", "light sleet", "moderate sleet", "light sleet showers", "moderate sleet showers":
            return "cloud.sleet.fill"
        case "patchy freezing drizzle possible", "heavy freezing drizzle", "light freezing rain", "moderate or heavy freezing rain":
            return "cloud.hail.fill"
        case "thundery outbreaks possible", "patchy light rain with thunder", "moderate or heavy rain with thunder", "patchy light snow with thunder", "moderate or heavy snow with thunder":
            return "cloud.bolt.rain.fill"
        case "blowing snow", "blizzard":
            return "cloud.snow.blizzard.fill"
        case "freezing fog":
            return "cloud.fog.fill"
        case "torrential rain shower", "moderate or heavy rain shower", "light rain shower":
            return "cloud.rain.fill"
        case "light snow showers", "moderate or heavy snow showers":
            return "cloud.snow.fill"
        case "light showers of ice pellets", "moderate or heavy showers of ice pellets":
            return "cloud.hail.fill"
        default:
            return "questionmark.circle"
    }
}
