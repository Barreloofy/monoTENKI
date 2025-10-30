//
// WeatherListSymbol.swift
// monoTENKI
//
// Created by Barreloofy on 8/28/25 at 8:38 PM
//

import SwiftUI

struct WeatherListSymbol: View {
  let name: String
  let isDay: Bool

  var body: some View {
    Image(systemName: name.formatted(.sfSymbols(isDay: isDay)))
      .configure()
      .aspectRatio(1, contentMode: .fit)
      .containerRelativeFrame(.vertical, count: 24, spacing: 0)
  }
}
