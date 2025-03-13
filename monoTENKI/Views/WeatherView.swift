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
        ZStack {
          /*
             Temporary fix for view rendering out of sync glitch until Apple reolves the issue.
             See here for more details: https://stackoverflow.com/questions/79441756/swiftui-sheet-causing-white-flickering-of-background
             */
            Color(.black).opacity(0.98).padding(-1).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ScrollView {
                    ContentView
                }
                .scrollIndicators(.hidden)
                
                Spacer()
            }
            .foregroundStyle(.white)
        }
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
                        .presentationBackground(.black)
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
