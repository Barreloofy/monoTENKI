//
//  ColorScheme+MainColors.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 6:22 PM.
//

import SwiftUI

extension ColorScheme {
  var foreground: Color {
    self == .light ? .black : .white
  }

  var background: Color {
    self == .light ? .white : .black
  }

  func transformForeground(condition: @autoclosure () -> Bool, transform: Color) -> Color {
    condition() ? transform : foreground
  }
}


@propertyWrapper struct ColorSchemeWrapper: DynamicProperty {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.nightVision) private var nightVision

  var wrappedValue: Color {
    colorScheme.transformForeground(condition: nightVision, transform: .nightRed)
  }

  var projectedValue: ColorScheme? {
    nightVision ? .dark : nil
  }

  var sheetValue: ColorScheme {
    nightVision ? .dark : colorScheme
  }
}
