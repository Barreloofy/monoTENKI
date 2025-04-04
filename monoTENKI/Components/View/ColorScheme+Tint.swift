//
//  ColorScheme+Tint.swift
//  monoTENKI
//
//  Created by Barreloofy on 3/31/25 at 6:22 PM.
//

import SwiftUI
// MARK: - Convenience method for buttons
extension ColorScheme {
  func tint() -> Color {
    return self == .light ? .black : .white
  }
}
