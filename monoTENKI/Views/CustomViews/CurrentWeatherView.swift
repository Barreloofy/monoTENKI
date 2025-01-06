//
//  CurrentWeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/5/25 at 9:48 PM.
//

import SwiftUI

struct CurrentWeatherView: View {
    let currentWeather: CurrentWeather
    let unit: UnitData.TemperatureUnits
    @State private var showSearch = false
    @State private var showSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            VStack {
                Text(currentWeather.location)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
                    .onTapGesture {
                        showSearch = true
                    }
                    .sheet(isPresented: $showSearch) {
                        SearchView()
                    }
                Text(presentTemperature(unit, currentWeather.tempC))
                temperatureExtremesView(mintemp: currentWeather.day.mintempC, maxtemp: currentWeather.day.maxtempC)
                    .font(.system(.title3, design: .serif, weight: .bold))
                Image(systemName: getWeatherIcon(for: currentWeather.condition, isDay: false))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fontWeight(.regular)
                    .padding()
                Text(currentWeather.condition)
                    .font(.system(.title, design: .serif, weight: .bold))
            }
            .font(.system(.largeTitle, design: .serif, weight: .bold))
            .frame(width: screenWidth * 0.66)
            .position(CGPoint(x: screenWidth / 2, y: screenHeight / 2))
        }
        .aspectRatio(contentMode: .fit)
    }
}
