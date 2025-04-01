//
//  ColorScheme+Tint.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 6:22 PM.
//

import SwiftUI

extension ColorScheme {
  func tint() -> Color {
    self == .light ? .black : .white
  }
}
