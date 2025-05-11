//
//  WeatherComposer.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI

struct WeatherComposer: View {
  @Environment(\.colorScheme) private var colorScheme

  @State private var presentSearch = false
  @State private var presentSettings = false

  let currentWeather: CurrentWeather
  let hourForecast: Hours
  let dayForecast: Days

  var body: some View {
    VStack(spacing: 25) {
      Row(
        leading: {},
        center: {
          Button(
            action: { presentSearch = true },
            label: { Text(currentWeather.location) })
          .sheet(isPresented: $presentSearch) {
            Search(setup: false)
              .presentationBackground(colorScheme.background)
          }
        },
        trailing: {
          Button(
            action: { presentSettings = true },
            label: {
              Image(systemName: "gear")
                .styled(size: 25)
            })
          .sheet(isPresented: $presentSettings) {
            Settings()
              .presentationBackground(colorScheme.background)
          }
        })
      .padding()

      ScrollView(.horizontal) {
        LazyHStack(spacing: 0) {
          ScrollView {
            LazyVStack(spacing: 0) {
              Today(current: currentWeather)
                .containerRelativeFrame(.vertical)

              HourForecast(hours: hourForecast)
                .containerRelativeFrame(.vertical)
            }
            .padding()
          }
          .scrollTargetBehavior(.paging)
          .scrollIndicators(.never)
          .containerRelativeFrame(.horizontal)

          DayForecast(days: dayForecast)
            .padding()
            .containerRelativeFrame(.horizontal)
        }
      }
      .ignoresSafeArea()
      .scrollTargetBehavior(.paging)
      .scrollIndicators(.never)
      .fontWeight(.bold)
    }
  }
}
