//
//  TodayDetails.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/3/25 at 12:25 PM.
//

import SwiftUI

struct TodayDetails: View {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.measurementSystem) private var measurementSystem

  @Binding var showDetails: Bool

  let weatherDetails: WeatherModel.CurrentWeather

  var body: some View {
    ZStack {
      Color(colorScheme == .light ? .white : .black).ignoresSafeArea()
      VStack(alignment: .leading, spacing: 10) {
        Text("Temperatures")
          .font(.title)
          .underline()
        VStack(alignment: .leading) {
          HStack {
            Text("Now")
            Text(weatherDetails.temperatures.temperatureCelsius.temperatureFormatter(measurementSystem))
          }

          HStack {
            Text("Feels Like")
            Text(weatherDetails.temperatures.feelsLikeCelsius.temperatureFormatter(measurementSystem))
          }

          HStack {
            Text("High")
            Text(weatherDetails.temperatures.temperatureCelsiusHigh.temperatureFormatter(measurementSystem))
          }

          HStack {
            Text("Low")
            Text(weatherDetails.temperatures.temperatureCelsiusLow.temperatureFormatter(measurementSystem))
          }

          HStack {
            Text("Humidity")
            Text(weatherDetails.temperatures.humidity, format: .percent)
          }
        }
        .offset(x: 10)

        Text("Precipitation")
          .font(.title)
          .underline()
        VStack(alignment: .leading) {
          HStack {
            Text("Chance")
            Text(weatherDetails.downfall.chance, format: .percent)
          }

          HStack {
            Text("Rate")
            Text(weatherDetails.downfall.rate.precipitationFormatter(measurementSystem))
          }

          HStack {
            Text("Total")
            Text(weatherDetails.downfall.total.precipitationFormatter(measurementSystem))
          }

          HStack {
            Text("Type")
            Text(weatherDetails.downfall.type)
          }
        }
        .offset(x: 10)

        Text("Wind")
          .font(.title)
          .underline()
        VStack(alignment: .leading) {
          HStack {
            Text("Direction")
            Text(weatherDetails.windDetails.windDirection)
          }

          HStack {
            Text("Speed")
            Text(weatherDetails.windDetails.windSpeed.SpeedFormatter(measurementSystem))
          }

          HStack {
            Text("Gust")
            Text(weatherDetails.windDetails.windGust.SpeedFormatter(measurementSystem))
          }
        }
        .offset(x: 10)
      }
      .font(.headline)
    }
    .padding(.horizontal, 25)
    .padding(.vertical, 55)
    .onTapGesture { showDetails = false }
  }
}


struct DetailsPage: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  @Binding var showDetails: Bool
  let weatherDetails: WeatherModel.CurrentWeather

  func body(content: Content) -> some View {
    content
      .overlay {
        if showDetails {
          ZStack {
            Color(colorScheme == .light ? .white : .black).safeAreaPadding(.top, 50)
            TodayDetails(showDetails: $showDetails, weatherDetails: weatherDetails)
          }
        }
      }
      .animation(.easeInOut.speed(0.5), value: showDetails)
  }
}


extension View {
  func detailsPage(isPresented: Binding<Bool>, weatherDetails: WeatherModel.CurrentWeather) -> some View {
    self.modifier(DetailsPage(showDetails: isPresented, weatherDetails: weatherDetails))
  }
}
