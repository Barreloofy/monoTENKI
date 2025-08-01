//
//  WeatherComposite.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI

struct WeatherComposite: View {
  @ColorSchemeWrapper private var colorSchemeWrapper

  @State private var presentSearch = false
  @SheetControllerWrapper private var settingsController

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
            .sheetConfiguration()
        }
      },
      trailing: {
        Button(
          action: { settingsController() },
          label: {
            Image(systemName: "gear")
              .styled(size: 25)
          })
        .sheet(isPresented: $settingsController) {
          Settings()
            .sheetConfiguration()
          // Fix for colorScheme not updating properly when sheet active // Doesn't work inside sheetConfiguration
            .preferredColorScheme(_colorSchemeWrapper.sheetValue)
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

        DayForecast(days: dayForecast)
      }
    }
    .ignoresSafeArea()
    .scrollTargetBehavior(.paging)
    .scrollIndicators(.never)
  }
}
