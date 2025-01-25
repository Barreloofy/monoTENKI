//
//  WeatherDetailView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 4:44 PM.
//

import SwiftUI

struct WeatherDetailView: View {
    @EnvironmentObject private var unitData: UnitData
    let details: CurrentWeatherDetails
    
    init(_ details: CurrentWeatherDetails) {
        self.details = details
    }
    
    var body: some View {
        TabView {
            WindDetailsView(details: details, unit: unitData.speed)
                .tag(0)
            FeelsDetailView(details: details, units: (temperature: unitData.temperature, measurement: unitData.measurement))
                .tag(1)
        }
        .tabViewStyle(.page)
        .font(.system(.title3, design: .serif, weight: .bold))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
}


struct WindDetailsView: View {
    let details: CurrentWeatherDetails
    let unit: UnitData.SpeedUnits
    
    var body: some View {
        VStack(alignment: .leading) {
            DetailRowView(title: "WIND DIRECTION", value: details.windDirection)
            DetailRowView(title: "WIND SPEED", value: presentSpeed(unit, details.windSpeedKph))
            DetailRowView(title: "WIND GUST", value: presentSpeed(unit, details.windGustKph))
        }
        .padding(.bottom, 10)
    }
}

struct FeelsDetailView: View {
    let details: CurrentWeatherDetails
    let units: (temperature: UnitData.TemperatureUnits, measurement: UnitData.MeasurementUnits)
    
    var body: some View {
        VStack(alignment: .leading) {
            DetailRowView(title: "PRECIPITATION", value: presentMeasurement(units.measurement, details.precipitationMm))
            DetailRowView(title: "HUMIDITY", value: "\(details.humidity) %")
            DetailRowView(title: "WIND CHILL", value: presentTemperature(units.temperature, details.windchillC))
        }
        .padding(.bottom, 10)
    }
}
