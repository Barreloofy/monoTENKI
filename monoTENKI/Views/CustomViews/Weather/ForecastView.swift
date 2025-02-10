//
//  ForecastView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/4/25 at 5:51 PM.
//

import SwiftUI

struct ForecastView: View {
    @EnvironmentObject private var unitData: UnitData
    let day: FutureDay
    let isDay: Bool
    
    private var weekday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: day.date)
    }
    
    var body: some View {
        VStack {
            Text(presentTemperature(unitData.temperature, day.avgtempC))
            TemperatureExtremesView(for: day)
                .font(.system(.headline, design: .serif, weight: .bold))
            WeatherConditionIconView(condition: day.condition, isDay: isDay)
            Spacer()
            Text(weekday)
        }
        .font(.system(.title3, design: .serif, weight: .bold))
    }
}

#Preview {
    ForecastView(day: FutureDay(), isDay: true)
        .environmentObject(UnitData())
}
