//
//  ContentView.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/16/25 at 8:31 PM.
//

import SwiftUI

struct ContentView: View {
  @State private var weatherModel = WeatherModel()
  @State private var locationManager = LocationManager()
  @AppStorage("lastLocation") private var text = ""
  @AppStorage("measurementSystem") private var useMetric = true
  @Environment(\.measurementSystem) private var measurementSystem

  var tempNow: Double {
    weatherModel.currentWeather.temperatures.temperatureCelsius
  }

  var body: some View {
    VStack {
      TextField("Enter location here", text: $text)
      Toggle("Use Metric", isOn: $useMetric)
      Text("It's currently \(tempNow.temperatureFormatter(measurementSystem)) in \(text)")
    }
    .padding(.horizontal)
    .task(id: text) {
      do {
        try await weatherModel.getWeather(for: text)
      } catch {
        print(error)
      }
    }
  }
}

#Preview {
  ContentView()
}
