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
            windDetails
                .tag(0)
            feelsDetails
                .tag(1)
        }
        .tabViewStyle(.page)
        .font(.system(.title3, design: .serif, weight: .bold))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
    
    @ViewBuilder var windDetails: some View {
        VStack(alignment: .leading) {
            DetailRowView(title: "WIND DIRECTION", value: details.windDirection)
            DetailRowView(title: "WIND SPEED", value: presentSpeed(unitData.speed, details.windSpeedKph))
            DetailRowView(title: "WIND GUST", value: presentSpeed(unitData.speed, details.windGustKph))
        }
        .padding(.bottom, 10)
    }
    
    @ViewBuilder var feelsDetails: some View {
        VStack(alignment: .leading) {
            DetailRowView(title: "PRECIPITATION", value: presentMeasurement(unitData.measurement, details.precipitationMm))
            DetailRowView(title: "HUMIDITY", value: "\(details.humidity) %")
            DetailRowView(title: "WIND CHILL", value: presentTemperature(unitData.temperature, details.windchillC))
        }
        .padding(.bottom, 10)
    }
}


#Preview {
    WeatherDetailView(CurrentWeatherDetails(windDirection: "NS", windSpeedKph: 25, windGustKph: 50, windchillC: 4.0, precipitationMm: 1.5, humidity: 80))
        .environmentObject(UnitData())
}
