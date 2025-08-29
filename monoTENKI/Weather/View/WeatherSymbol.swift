//
// WeatherSymbol.swift
// monoTENKI
//
// Created by Barreloofy on 8/28/25 at 6:50 PM
//

import SwiftUI

struct WeatherSymbol: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  let name: String
  let isDay: Bool

  private let largeSizeThreshold = 1032.0
  private let largeSizeFraction = 0.25

  private let regularSizeFraction = 0.5
  private let compactSizeFraction = 0.75

  var body: some View {
    Image(systemName: name.formatted(.sfSymbols(isDay: isDay)))
      .configure()
      .containerRelativeFrame(.horizontal, alignment: .top) { length, _ in
        if length > largeSizeThreshold {
          length * largeSizeFraction
        } else {
          length * (horizontalSizeClass == .regular ? regularSizeFraction : compactSizeFraction)
        }
      }
  }
}


#Preview {
  WeatherSymbol(name: "cloud", isDay: true)
}
