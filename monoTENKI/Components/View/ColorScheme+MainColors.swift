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
}
