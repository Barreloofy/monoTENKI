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
                contentBlock
            }
            .scrollIndicators(.hidden)
            
            Spacer()
        }
        .foregroundStyle(.white)
        .background(Color(.black)
            .opacity(0.98)
            .padding(-1)
            .ignoresSafeArea()
        )
        /*
            Temporary fix for view rendering out of sync glitch until Apple resolves the issue.
            See here for more details: https://stackoverflow.com/questions/79441756/swiftui-sheet-causing-white-flickering-of-background
          */
    }
    
    
    @ViewBuilder private var contentBlock: some View {
        VStack {
            AlignedHStack(alignment: .trailing) {
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
        }
        .padding()
    }
}
