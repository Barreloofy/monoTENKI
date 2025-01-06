//
//  HourForecastView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/5/25 at 10:07 PM.
//

import SwiftUI

struct HourForecastView: View {
    let hourForecast: [Hour]
    let unit: UnitData.TemperatureUnits
    
    var body: some View {
        HStack {
            Text("FORECAST 12")
                .font(.system(.title3, design: .rounded, weight: .bold))
            Spacer()
        }
        ForEach(hourForecast, id: \.date) { hour in
            ZStack {
                HStack {
                    Text(hour.date.formatted(date: .omitted, time: .shortened))
                    Spacer()
                }
                Image(systemName: getWeatherIcon(for: hour.condition.text, isDay: false))
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
