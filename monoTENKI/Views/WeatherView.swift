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
    @State private var isError = false
    
    var body: some View {
        Group {
            if isError {
                ErrorView(isError: $isError)
            } else {
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
                .onChange(of: weatherData.currentLocation, initial: true) {
                    weatherData.fetchWeather() { error in
                        guard let _ = error else { return }
                        isError = true
                    }
                }
            }
        }
        .environmentObject(weatherData)
    }
}

#Preview {
    WeatherView()
        .environmentObject(UnitData())
        .environmentObject(WeatherData())
}
