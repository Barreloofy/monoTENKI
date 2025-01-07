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
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.98)
                .ignoresSafeArea()
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
                        HStack {
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
            .onChange(of: weatherData.currentLocation, initial: true) {
                weatherData.fetchWeather()
            }
            .environmentObject(weatherData)
            .blur(radius: showAlert ? 5 : 0)
            if showAlert {
                AlertView()
            }
        }
    }
}

#Preview {
    WeatherView()
        .environmentObject(UnitData())
        .environmentObject(WeatherData())
}
