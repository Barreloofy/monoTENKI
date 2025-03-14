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
            AlignedHStack(alignment: .leading) {
                Text("FORECAST 12H")
                    .font(.system(.title3, design: .monospaced, weight: .bold))
            }
            
            ForecastList
        }
    }
    
    @ViewBuilder private var ForecastList: some View {
        ForEach(hourForecast, id: \.time) { hour in
            ZStack {
                AlignedHStack(alignment: .leading) {
                    Text(presentTime(for: hour.time))
                }
                
                Image(systemName: presentIcon(
                    for: hour.condition.text,
                    isDay: determineIsDay(for: hour.time)))
                    .fontWeight(.regular)
                
                AlignedHStack(alignment: .trailing) {
                    Text(presentTemperature(for: unit, with: hour.tempC))
                }
            }
            .font(.system(.title, design: .monospaced, weight: .bold))
        }
    }
}
