//
//  EntryView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/8/25 at 9:34 PM.
//

import SwiftUI

struct EntryView: View {
    @StateObject private var weatherData = WeatherData()
    @AppStorage("isfirstlaunch") private var isFirstLaunch = true
    @State private var isError = false
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isFirstLaunch {
                SetUpView()
            } else if isError {
                ErrorView(isError: $isError)
            } else if isLoading {
                ZStack {
                    Color(.black).ignoresSafeArea()
                }
            } else {
                WeatherView()
            }
        }
        .onChange(of: weatherData.currentLocation, initial: true) {
            weatherData.fetchWeather() { result in
                switch result {
                    case .success():
                        isLoading = false
                    case .failure(_):
                        isError = true
                }
            }
        }
        .environmentObject(weatherData)
    }
}

#Preview {
    EntryView()
        .environmentObject(UnitData())
}
