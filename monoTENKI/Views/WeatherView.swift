//
//  WeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 2:18 AM.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var weatherData: WeatherData
    @EnvironmentObject private var unitData: UnitData
    @State private var showSettings = false
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            showSettings = true
                        } label: {
                            SettingsIcon()
                        }
                        .sheet(isPresented: $showSettings) {
                            SettingsView()
                        }
                    }
                    CurrentWeatherView()
                    HStack(alignment: .top) {
                        ForEach(weatherData.dayForecast) { day in
                            ForecastView(day: day, isDay: weatherData.isDay)
                        }
                    }
                    .padding()
                    HourForecastView()
                    Spacer()
                }
                .padding()
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .background(.black.opacity(0.98))
    }
}
