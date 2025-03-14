//
//  ForecastView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/4/25 at 5:51 PM.
//

import SwiftUI

struct ForecastView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @EnvironmentObject private var unitData: UnitData
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(weatherData.dayForecast) { day in
                createForecastBlock(for: day)
            }
        }
    }
    
    
    @ViewBuilder private func createForecastBlock(for day: FutureDay) -> some View {
        VStack {
            Text(presentTemperature(for: unitData.temperature, with: day.avgtempC))
            
            TemperatureExtremesView(for: day)
                .font(.system(.headline, design: .serif, weight: .bold))
            
            ConditionIconView(condition: day.condition, isDay: true)
            
            Spacer()
            
            Text(presentWeekday(for: day.date))
        }
        .font(.system(.title3, design: .serif, weight: .bold))
    }
}

#Preview {
    ForecastView()
        .environmentObject(UnitData())
        .environmentObject(WeatherData())
}
