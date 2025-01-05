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
    var body: some View {
        VStack {
            Text(presentTemperature(unitData.temperature, day.avgtempC))
            Image(systemName: getWeatherIcon(for: day.condition.text, isDay: false))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .fontWeight(.regular)
            HStack {
                Text("L: \(presentTemperature(unitData.temperature, day.mintempC))")
                Text("H: \(presentTemperature(unitData.temperature, day.maxtempC))")
            }
        }
        .font(.system(.title3, design: .serif, weight: .bold))
    }
}

#Preview {
    ForecastView(day: Day(maxtempC: 0.0, mintempC: 0.0, avgtempC: 0.0, condition: Condition(text: "")))
        .environmentObject(UnitData())
}