//
//  PresenterFunctions.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/5/25 at 8:34 PM.
//

import Foundation

// MARK: - Data conversion functions used throughout the app

func presentTemperature(_ unit: UnitData.TemperatureUnits, _ tempCDouble: Double) -> String {
    let degreeSymbol = "\u{00B0}"
    
    if unit == .celsius {
        return String(Int(tempCDouble)) + degreeSymbol
    } else {
        let tempFInt = Int(tempCDouble * (9/5) + 32)
        return String(tempFInt) + degreeSymbol
    }
}

func presentSpeed(_ unit: UnitData.SpeedUnits, _ speedKphDouble: Double) -> String {
    if unit == .kilometersPerHour {
        return String(Int(speedKphDouble)) + " " + "KM/H"
    } else {
        let speedMphInt = Int(speedKphDouble / 1.609344)
        return String(speedMphInt) + " " + "MP/H"
    }
}

func presentMeasurement(_ unit: UnitData.MeasurementUnits, _ measurementMmDouble: Double) -> String {
    if unit == .millimeter {
        return String(format: "%.2f",measurementMmDouble) + " " + "MM"
    } else {
        let measurementInDouble = measurementMmDouble * 0.0393700787
        return String(format: "%.2f", measurementInDouble) + " " + "IN"
    }
}

func presentTime(for time: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "h:mm"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    let outTime = dateFormatter.string(from: time)
    return outTime
}

func presentWeekday(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "EEEE"
    
    return dateFormatter.string(from: date)
}

func determineIsDay(_ time: Date) -> Bool {
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "HH"
    
    let hourString = dateFormatter.string(from: time)
    
    guard let hourInt = Int(hourString) else { return true }
    
    return hourInt > 6 && hourInt < 18
}

func presentIcon(for condition: String, isDay: Bool) -> String {
    let condition = condition.trimmingCharacters(in: .whitespaces).lowercased()
    
    let sunnyClear = /(sunny|clear)/
    let partlyCloudy = /partly cloudy/
    let cloudy = /(cloudy|overcast)/
    let fogMist = /(fog|mist)/
    let rainDrizzle = /(rain|drizzle)/
    let snow = /snow/
    let sleet = /sleet/
    let freezing = /freezing/
    let thunder = /thunder/
    let blizzard = /(blizzard|blowing snow)/
    
    switch condition {
    case let condition where condition.contains(sunnyClear):
      return isDay ? "sun.max.fill" : "moon.fill"
    case let condition where condition.contains(partlyCloudy):
      return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
    case let condition where condition.contains(cloudy):
      return "cloud.fill"
    case let condition where condition.contains(fogMist):
      return "cloud.fog.fill"
    case let condition where condition.contains(rainDrizzle):
      return "cloud.rain.fill"
    case let condition where condition.contains(snow):
      return "cloud.snow.fill"
    case let condition where condition.contains(sleet):
      return "cloud.sleet.fill"
    case let condition where condition.contains(freezing):
      return "cloud.hail.fill"
    case let condition where condition.contains(thunder):
      return "cloud.bolt.rain.fill"
    case let condition where condition.contains(blizzard):
      return "wind.snow"
    default:
      return "cloud.fill"
    }
}
