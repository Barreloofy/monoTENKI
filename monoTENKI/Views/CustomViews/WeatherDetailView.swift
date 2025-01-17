//
//  WeatherDetailView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 4:44 PM.
//

import SwiftUI

struct WeatherDetailView: View {
    @EnvironmentObject private var unitData: UnitData
    let details: CurrentWeatherDetails
    
    init(_ details: CurrentWeatherDetails) {
        self.details = details
    }
    
    var body: some View {
        TabView {
            WindDetailsView(details: details, unit: unitData.speed)
                .tag(0)
        }
        .tabViewStyle(.page)
        .font(.system(.title3, design: .serif, weight: .bold))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
}


struct WindDetailsView: View {
    let details: CurrentWeatherDetails
    let unit: UnitData.SpeedUnits
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("WIND DIRECTION")
                Spacer()
                Text("\(details.windDirection)")
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 2)
            }
            HStack {
                Text("WIND SPEED")
                Spacer()
                Text(presentSpeed(unit, details.windSpeedKph))
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 2)
            }
            HStack {
                Text("WIND GUST")
                Spacer()
                Text(presentSpeed(unit, details.windGustKph))
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 2)
            }
        }
        .padding(.bottom, 10)
    }
}
