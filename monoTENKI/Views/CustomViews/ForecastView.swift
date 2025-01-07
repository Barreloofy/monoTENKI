//
//  ForecastView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/4/25 at 5:51 PM.
//

import SwiftUI

struct ForecastView: View {
    @EnvironmentObject private var unitData: UnitData
    
    let day: Day
    let isDay: Bool
    var body: some View {
        VStack {
            Text(presentTemperature(unitData.temperature, day.avgtempC))
            temperatureExtremesView(mintemp: day.mintempC, maxtemp: day.maxtempC)
                .font(.system(.headline, design: .serif, weight: .bold))
            Image(systemName: getWeatherIcon(for: day.condition.text, isDay: isDay))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .fontWeight(.regular)
                .shadow(color: .white, radius: 10, x: 5, y: 5)
                .padding()
        }
        .font(.system(.title3, design: .serif, weight: .bold))
    }
}

#Preview {
    ForecastView(day: Day(maxtempC: 0.0, mintempC: 0.0, avgtempC: 0.0, condition: Condition(text: "")), isDay: true)
        .environmentObject(UnitData())
}
