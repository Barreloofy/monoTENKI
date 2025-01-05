//
//  WeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 2:18 AM.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var unitData: UnitData
    @StateObject private var weatherData = WeatherData()
    @State private var showSettings = false
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        SettingsIcon(width: 50, height: 50)
                            .sheet(isPresented: $showSettings) {
                                SettingsView()
                            }
                            .onTapGesture {
                                showSettings = true
                            }
                    }
                    CurrentWeatherView(currentWeather: weatherData.currentWeather, unit: unitData.temperature)
                    HStack {
                        ForEach(weatherData.dayForecast) { day in
                            ForecastView(day: day)
                        }
                    }
                    .padding()
                    HourForecastView(hourForecast: weatherData.hourForecast, unit: unitData.temperature)
                    Spacer()
                }
                .padding()
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .background(.black)
        .onAppear {
            weatherData.fetchWeather(weatherData.currentLocation)
        }
        .onChange(of: weatherData.currentLocation) {
            weatherData.fetchWeather(weatherData.currentLocation)
        }
        .environmentObject(weatherData)
    }
}

#Preview {
    WeatherView()
        .environmentObject(UnitData())
}
