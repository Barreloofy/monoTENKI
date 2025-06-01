//
// WeatherIcon.swift
// monoTENKI
//
// Created by Barreloofy on 6/1/25 at 12:38 PM
//

import SwiftUI

struct WeatherIcon: View {
  let name: String
  let isDay: Bool
  let size: CGFloat

  var body: some View {
    Image(systemName: name.presentIcon(isDay: isDay))
      .styled(size: size)
      .accessibilityLabel(name)
  }
}
