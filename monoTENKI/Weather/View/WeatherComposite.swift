//
//  WeatherComposite.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI

struct WeatherComposite: View {
  @StyleMode private var styleMode

  @State private var presentSearch = false
  @SheetController private var settingsController

  let currentWeather: CurrentWeather
  let hourForecast: Hours
  let dayForecast: Days

  var body: some View {
    Row(
      center: {
        Button(
          action: { presentSearch = true },
          label: {
            Text(currentWeather.location)
              .fontWeight(.medium)
          })
        .sheet(isPresented: $presentSearch) {
          Search(setup: false)
            .configureSheet()
        }
      },
      trailing: {
        Button(
          action: { settingsController() },
          label: {
            Image(systemName: "gear")
              .font(.title2)
              .fontWeight(.regular)
          })
        .sheet(isPresented: $settingsController) {
          Settings()
            .configureSheet()
            .preferredColorScheme(_styleMode.sheetValue) // Fix for colorScheme not updating properly when sheet active.
            .sheetController(_settingsController())
        }
      })
    .padding()

    ScrollView(.horizontal) {
      LazyHStack(spacing: 0) {
        ScrollView(.vertical) {
          LazyVStack(spacing: 0) {
            Today(current: currentWeather)

            HourForecast(hours: hourForecast)
          }
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.never)
        .containerRelativeFrame(.horizontal)

        DayForecast(days: dayForecast)
      }
    }
    .scrollTargetBehavior(.paging)
    .scrollIndicators(.never)
    .ignoresSafeArea()
  }
}
