//
// WeatherSymbol.swift
// monoTENKI
//
// Created by Barreloofy on 11/4/25 at 5:00 PM
//

import SwiftUI

struct WeatherSymbol: View {
  let name: String
  let isDay: Bool

  private var formattedName: String {
    name.formatted(.sfSymbols(isDay: isDay))
  }

  var body: some View {
    Image(systemName: formattedName)
  }
}
