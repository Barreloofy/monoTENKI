//
//  WeatherComposite.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/30/25 at 9:15 PM.
//

import SwiftUI

// `verticalScrollPosition`, `horizontalScrollPosition` and their `.id()` and `.scrollPosition()` methods are need for iPadOS
// 26.0* window resizing system, as window size changes ScrollView items may unaligne themselves when not reseting the positions.

struct WeatherComposite: View {
  @StyleMode private var styleMode

  @State private var presentSearch = false
  @State private var verticalScrollPosition: String?
  @State private var horizontalScrollPosition: String?
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
        .applyGlassButtonStyleIfAvailable()
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
              .configureSettingsIcon()
          })
        .applyGlassButtonStyleIfAvailable()
        .sheet(isPresented: $settingsController) {
          Settings()
            .configureSheet()
            .sheetController(_settingsController())
            .preferredColorScheme(_styleMode.sheetValue) // Fix for colorScheme not updating properly when sheet active.
        }
      })
    .padding()

    ScrollView(.horizontal) {
      LazyHStack(spacing: 0) {
        ScrollView(.vertical) {
          LazyVStack(spacing: 0) {
            Today(current: currentWeather)
              .id("Today")

            HourForecast(hours: hourForecast)
              .id("HourForecast")
          }
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $verticalScrollPosition)
        .scrollIndicators(.never)
        .containerRelativeFrame(.horizontal)
        .id("Vertical")

        DayForecast(days: dayForecast)
          .id("DayForecast")
      }
    }
    .scrollTargetBehavior(.paging)
    .scrollPosition(id: $horizontalScrollPosition)
    .scrollIndicators(.never)
    .ignoresSafeArea()
    .onGeometryChange(
      for: CGSize.self,
      of: { geometry in
        geometry.size
      },
      action: { _ in
        verticalScrollPosition = "Today"
        horizontalScrollPosition = "Vertical"
      })
  }
}
