//
//  WeatherView.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI

struct WeatherView: View {
  @Environment(LocationModel.self) private var locationModel
  @Environment(\.measurementSystem) private var measurementSystem
  @Environment(\.colorScheme) private var colorScheme

  @State private var weatherModel = WeatherModel()
  @State private var showSettings = false
  @State private var showSearch = false

  var body: some View {
    VStack {
      ZStack {
        Button(
          action: { showSearch = true },
          label: {
            Text(verbatim: weatherModel.currentWeather.location)
              .fontWeight(.medium)
              .fontDesign(.monospaced)
          })
        .sheet(isPresented: $showSearch) {
          SearchWeather()
            .presentationBackground(colorScheme == .light ? .white : .black)
        }

        AlignedHStack(alignment: .trailing) {
          Button(
            action: { showSettings = true },
            label: {
              Image(systemName: "gear")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
            })
          .sheet(isPresented: $showSettings) {
            Settings()
              .presentationBackground(colorScheme == .light ? .white : .black)
          }
        }
      }
      .tint(colorScheme.tint())
      .padding(.top, 25)
      .padding(.bottom, 50)

      Today(weatherDetails: weatherModel.currentWeather)
    }
    .padding()
    .task(id: locationModel.location) {
      do {
        try await weatherModel.getWeather(for: locationModel.location)
      } catch {
        print(error)
      }
    }
  }
}
