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
                ContentView
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .background(.black.opacity(0.98))
    }
    
    @ViewBuilder private var ContentView: some View {
        VStack {
            HStackContent(orientation: .trailing) {
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
            .padding(5)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black.opacity(0.96))
                    .stroke(.white, lineWidth: 2)
                    .shadow(color: .white, radius: 5)
            }
            .padding()
            HourForecastView()
            Spacer()
        }
        .padding()
    }
}
