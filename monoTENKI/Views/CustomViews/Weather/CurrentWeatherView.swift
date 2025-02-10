//
//  CurrentWeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/5/25 at 9:48 PM.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @EnvironmentObject private var unitData: UnitData
    @State private var showSearch = false
    @State private var showDetails = false
    
    private var currentWeather: CurrentWeather {
        return weatherData.currentWeather
    }
    
    private var unit: UnitData.TemperatureUnits {
        return unitData.temperature
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            VStack {
                Text(currentWeather.location)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .onTapGesture {
                        showSearch = true
                    }
                    .sheet(isPresented: $showSearch) {
                        SearchView()
                    }
                Text(presentTemperature(unit, currentWeather.tempC))
                TemperatureExtremesView(for: currentWeather.day)
                    .font(.system(.title3, design: .serif, weight: .bold))
                Group {
                    if showDetails {
                        WeatherDetailView(currentWeather.details)
                            .onTapGesture {
                                showDetails = false
                            }
                    }
                    else {
                        WeatherConditionIconView(condition: currentWeather.condition, isDay: weatherData.isDay)
                            .onTapGesture {
                                showDetails = true
                            }
                    }
                }
                .frame(maxHeight: .infinity)
                Text(currentWeather.condition)
                    .font(.system(.title, design: .serif, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .font(.system(.largeTitle, design: .serif, weight: .bold))
            .frame(width: screenWidth * 0.666)
            .position(CGPoint(x: screenWidth / 2, y: screenHeight / 2))
        }
        .scaledToFit()
    }
}

#Preview {
    CurrentWeatherView()
        .environmentObject(WeatherData())
        .environmentObject(UnitData())
}
