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
            action: { presentSettings = true },
            label: {
              Image(systemName: "gear")
                .styled(size: 25)
            })
          .sheet(isPresented: $presentSettings) {
            Settings()
              .sheetConfiguration()
          }
        })
      .padding()

      ScrollView(.horizontal) {
        LazyHStack(spacing: 0) {
          ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
              Today(current: currentWeather)
                .containerRelativeFrame(.vertical, alignment: .top)

              HourForecast(hours: hourForecast)
                .containerRelativeFrame(.vertical, alignment: .top)
            }
          }
          .padding(.horizontal)
          .containerRelativeFrame(.horizontal)
          .scrollTargetBehavior(.paging)
          .scrollIndicators(.never)

          DayForecast(days: dayForecast)
            .padding(.horizontal)
            .containerRelativeFrame([.vertical, .horizontal], alignment: .top)
        }
      }
      .ignoresSafeArea()
      .scrollTargetBehavior(.paging)
      .scrollIndicators(.never)
    }
  }
}
