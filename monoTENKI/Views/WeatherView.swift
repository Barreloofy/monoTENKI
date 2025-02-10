//
//  WeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/1/25 at 2:18 AM.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var unitData: UnitData
    @EnvironmentObject private var weatherData: WeatherData
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
            ForecastView()
                .weatherCardStyle()
            HourForecastView()
                .weatherCardStyle()
            Spacer()
        }
        .padding()
    }
}
