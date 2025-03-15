//
//  CurrentWeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/5/25 at 9:48 PM.
//

import SwiftUI

struct CurrentWeatherView: View {
  @EnvironmentObject private var weatherData: WeatherData
  @EnvironmentObject private var unitData: UnitData
  @State private var showSearch = false
  @State private var showDetails = false

  private var currentWeather: CurrentWeather {
    return weatherData.currentWeather
  }

  private var unit: UnitData.TemperatureUnits {
    return unitData.temperature
  }

  var body: some View {
    GeometryReader { geometry in

      let screenWidth = geometry.size.width
      let screenHeight = geometry.size.height

      contentBlock
        .font(.system(.largeTitle, design: .serif, weight: .bold))
        .frame(width: screenWidth * (2 / 3))
        .position(CGPoint(x: screenWidth / 2, y: screenHeight / 2))
    }
    .scaledToFit()
  }

  @ViewBuilder private var contentBlock: some View {
    VStack {
      Text(currentWeather.location)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .onTapGesture { showSearch = true }
        .sheet(isPresented: $showSearch) {
          SearchView()
            .presentationBackground(.black)
        }

      Text(presentTemperature(for: unit, with: currentWeather.tempC))

      TemperatureExtremesView(for: currentWeather.day)
        .font(.system(.title3, design: .serif, weight: .bold))

      conditionToggleBlock
        .frame(maxHeight: .infinity)

      Text(currentWeather.condition)
        .font(.system(.title, design: .serif, weight: .bold))
        .lineLimit(2)
        .minimumScaleFactor(0.8)
        .multilineTextAlignment(.center)
    }
  }


  @ViewBuilder private var conditionToggleBlock: some View {
    if showDetails {
      WeatherDetailView()
        .onTapGesture { showDetails = false }
    } else {
      ConditionIconView(
        condition: currentWeather.condition,
        isDay: determineIsDay(for: currentWeather.day.date))
        .onTapGesture { showDetails = true }
    }
  }
}

#Preview {
  CurrentWeatherView()
    .environmentObject(WeatherData())
    .environmentObject(UnitData())
}
