//
//  ForecastView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/4/25 at 5:51 PM.
//

import SwiftUI

struct ForecastView: View {
    @EnvironmentObject private var unitData: UnitData
    @EnvironmentObject private var weatherData: WeatherData
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(weatherData.dayForecast) { day in
                forecastDay(day)
            }
        }
    }
    
    @ViewBuilder private func forecastDay(_ day: FutureDay) -> some View {
        VStack {
            Text(presentTemperature(unitData.temperature, day.avgtempC))
            TemperatureExtremesView(for: day)
                .font(.system(.headline, design: .serif, weight: .bold))
            WeatherConditionIconView(condition: day.condition, isDay: true)
            Spacer()
            Text(presentWeekday(day.date))
        }
        .font(.system(.title3, design: .serif, weight: .bold))
    }
}

#Preview {
    ForecastView()
        .environmentObject(UnitData())
        .environmentObject(WeatherData())
}
