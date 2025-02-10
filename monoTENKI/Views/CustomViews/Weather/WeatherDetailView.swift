//
//  WeatherDetailView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 4:44 PM.
//

import SwiftUI

struct WeatherDetailView: View {
    @EnvironmentObject private var unitData: UnitData
    @EnvironmentObject private var weatherData: WeatherData
    
    var details: CurrentWeatherDetails {
        weatherData.currentWeather.details
    }
    
    var body: some View {
        TabView {
            WindDetails
                .tag(0)
            FeelsDetails
                .tag(1)
        }
        .tabViewStyle(.page)
        .font(.system(.title3, design: .serif, weight: .bold))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
    
    @ViewBuilder var WindDetails: some View {
        VStack(alignment: .leading) {
            DetailRow(title: "WIND DIRECTION", value: details.windDirection)
            DetailRow(title: "WIND SPEED", value: presentSpeed(unitData.speed, details.windSpeedKph))
            DetailRow(title: "WIND GUST", value: presentSpeed(unitData.speed, details.windGustKph))
        }
        .padding(.bottom, 10)
    }
    
    @ViewBuilder var FeelsDetails: some View {
        VStack(alignment: .leading) {
            DetailRow(title: "PRECIPITATION", value: presentMeasurement(unitData.measurement, details.precipitationMm))
            DetailRow(title: "HUMIDITY", value: "\(details.humidity) %")
            DetailRow(title: "WIND CHILL", value: presentTemperature(unitData.temperature, details.windchillC))
        }
        .padding(.bottom, 10)
    }
    
    @ViewBuilder func DetailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 2)
        }
    }
}


#Preview {
    WeatherDetailView()
        .environmentObject(UnitData())
        .environmentObject(WeatherData())
}
