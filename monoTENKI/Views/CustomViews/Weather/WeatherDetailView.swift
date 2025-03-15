//
//  WeatherDetailView.swift
//  monoTENKI
//
//  Created by Barreloofy on 1/17/25 at 4:44 PM.
//

import SwiftUI

struct WeatherDetailView: View {
  @EnvironmentObject private var unitData: UnitData
  @EnvironmentObject private var weatherData: WeatherData

  private var details: CurrentWeatherDetails {
    weatherData.currentWeather.details
  }

  var body: some View {
    TabView {
      windBlock
        .tag(0)

      feelsBlock
        .tag(1)
    }
    .tabViewStyle(.page)
    .font(.system(.title3, design: .serif, weight: .bold))
    .lineLimit(1)
    .minimumScaleFactor(0.8)
  }


  @ViewBuilder private var windBlock: some View {
    VStack(alignment: .leading) {
      createDetailBlock(title: "WIND DIRECTION", value: details.windDirection)

      createDetailBlock(
        title: "WIND SPEED",
        value: presentSpeed(for: unitData.speed, with: details.windSpeedKph))

      createDetailBlock(
        title: "WIND GUST",
        value: presentSpeed(for: unitData.speed, with: details.windGustKph))
    }
    .padding(.bottom, 10)
  }


  @ViewBuilder private var feelsBlock: some View {
    VStack(alignment: .leading) {
      createDetailBlock(
        title: "PRECIPITATION",
        value: presentMeasurement(for: unitData.measurement, with: details.precipitationMm))

      createDetailBlock(title: "HUMIDITY", value: "\(details.humidity) %")

      createDetailBlock(
        title: "WIND CHILL",
        value: presentTemperature(for: unitData.temperature, with: details.windchillC))
    }
    .padding(.bottom, 10)
  }


  @ViewBuilder private func createDetailBlock(title: String, value: String) -> some View {
    HStack {
      Text(title)

      Spacer()

      Text(value)
    }
    .overlay(alignment: .bottom) {
      Rectangle()
        .frame(height: 2)
    }
  }
}


#Preview {
  WeatherDetailView()
    .environmentObject(UnitData())
    .environmentObject(WeatherData())
}
