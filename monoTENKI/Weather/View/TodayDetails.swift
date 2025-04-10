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

  let weatherDetails: CurrentWeather

  var body: some View {
    ZStack {
      Color(colorScheme.background).safeAreaPadding(.top, 50)
      VStack(alignment: .leading, spacing: 10) {
        DetailSection(title: "Temperatures") {
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


        DetailSection(title: "Precipitation") {
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

        DetailSection(title: "Wind") {
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
      }
    }
    .onTapGesture { showDetails = false }
  }
}


extension TodayDetails {
  @ViewBuilder func DetailSection<Content: View>(
    title: String,
    @ViewBuilder content: () -> Content) -> some View {
      Text(title)
        .font(.title)
        .underline()
      VStack(alignment: .leading) {
        content()
      }
      .offset(x: 10)
    }
}


struct TodayDetailsPage: ViewModifier {
  @Binding var showDetails: Bool
  let weatherDetails: CurrentWeather

  func body(content: Content) -> some View {
    content
      .overlay {
        if showDetails { TodayDetails(showDetails: $showDetails, weatherDetails: weatherDetails) }
      }
      .animation(.easeInOut.speed(0.5), value: showDetails)
  }
}


extension View {
  func todayDetailsPage(isPresented: Binding<Bool>, weatherDetails: CurrentWeather) -> some View {
    self.modifier(TodayDetailsPage(showDetails: isPresented, weatherDetails: weatherDetails))
  }
}
