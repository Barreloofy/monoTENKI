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
        VStack {
            HStackContent(orientation: .leading) {
                Text("FORECAST 12H")
                    .font(.system(.title3, design: .monospaced, weight: .bold))
            }
            ForEach(hourForecast, id: \.time) { hour in
                ZStack {
                    HStackContent(orientation: .leading) {
                        Text(presentTime(for: hour.time))
                    }
                    Image(systemName: getWeatherIcon(for: hour.condition.text, isDay: weatherData.isDay))
                        .fontWeight(.regular)
                    HStackContent(orientation: .trailing) {
                        Text(presentTemperature(unit, hour.tempC))
                    }
                }
                .font(.system(.title, design: .monospaced, weight: .bold))
            }
        }
        .padding()
        .weatherCardStyle()
        .padding()
    }
}
