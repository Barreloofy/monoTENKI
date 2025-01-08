//
//  HourForecastView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/5/25 at 10:07 PM.
//

import SwiftUI

struct HourForecastView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @EnvironmentObject private var unitData: UnitData
    
    private var hourForecast: [Hour] {
        return weatherData.hourForecast
    }
    
    private var unit: UnitData.TemperatureUnits {
        return unitData.temperature
    }
    
    var body: some View {
        HStack {
            Text("FORECAST 12H")
                .font(.system(.title3, design: .rounded, weight: .bold))
            Spacer()
        }
        ForEach(hourForecast, id: \.time) { hour in
            ZStack {
                HStack {
                    Text(hour.time.formatted(date: .omitted, time: .shortened))
                    Spacer()
                }
                Image(systemName: getWeatherIcon(for: hour.condition.text, isDay: weatherData.isDay))
                    .fontWeight(.regular)
                HStack {
                    Spacer()
                    Text(presentTemperature(unit, hour.tempC))
                }
            }
            .font(.system(.title, design: .serif, weight: .bold))
        }
    }
}
