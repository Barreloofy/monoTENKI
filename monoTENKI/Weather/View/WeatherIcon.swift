//
// WeatherIcon.swift
// monoTENKI
//
// Created by Barreloofy on 6/1/25 at 12:38 PM
//

import SwiftUI

struct WeatherIcon: View {
  enum IconUsage {
    case primary, overview
    case custom(CGFloat)
  }

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  let name: String
  let isDay: Bool
  let usage: IconUsage

  private var size: CGFloat {
    switch usage {
    case .primary:
      horizontalSizeClass == .compact ? 250 : 375
    case .overview:
      horizontalSizeClass == .compact ? 30 : 45
    case .custom(let value):
      value
    }
  }

  var body: some View {
    Image(systemName: name.formatted(.sfSymbols(isDay: isDay)))
      .styled(size: size)
      .accessibilityLabel(name)
  }
}
