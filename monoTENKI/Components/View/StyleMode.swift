//
// StyleMode.swift
// monoTENKI
//
// Created by Barreloofy on 8/27/25 at 12:25 PM
//

import SwiftUI

/// A property wrapper through which you retrieve the current foreground style and scheme.
@propertyWrapper struct StyleMode: DynamicProperty {
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.nightVision) private var nightVision

  var wrappedValue: Color {
    colorScheme.transformForeground(to: .nightRed, condition: nightVision)
  }

  /// Returns the `dark` scheme if `nightVision` is true, else the system one.
  var projectedValue: ColorScheme? {
    nightVision ? .dark : nil
  }

  /// Returns the `dark` scheme if `nightVision` is true, else the system one.
  ///
  /// > Warning:
  /// This property's sole purpose is to fix a bug that prevents `projectedValue` from working inside sheets.
  /// Using this property outside a sheet context causes undefined behavior.
  var sheetValue: ColorScheme {
    nightVision ? .dark : colorScheme
  }
}
