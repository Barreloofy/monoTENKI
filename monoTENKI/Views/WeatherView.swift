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
                        Button {
                            showSettings = true
                        } label: {
                            SettingsIcon()
                        }
                        .sheet(isPresented: $showSettings) {
                            SettingsView()
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
            weatherData.fetchWeather()
        }
        .onChange(of: weatherData.currentLocation) {
            weatherData.fetchWeather()
        }
        .environmentObject(weatherData)
    }
}

#Preview {
    WeatherView()
        .environmentObject(UnitData())
        .environmentObject(WeatherData())
}
