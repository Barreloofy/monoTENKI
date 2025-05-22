//
//  XIconStyle.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/23/25.
//

import SwiftUI
// Convenience property for 'Shape'
extension Shape {
  var iconStyleX: some View {
    self
      .stroke(lineWidth: 3)
      .frame(width: 20, height: 20)
  }
}
