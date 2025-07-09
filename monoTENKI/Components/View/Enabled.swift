//
//  Enabled.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/3/25.
//

import SwiftUI

extension View {
  /// Conditionally shows the view it is applied to.
  /// - Parameters:
  ///   - condition: If this value evaluates to true shows the view it is applied to.
  /// - Returns: A view that conditionally shows the view it is applied to.
  @ViewBuilder func enabled(_ condition: Bool) -> some View {
    if condition { self }
  }

  /// Conditionally shows the view it is applied to.
  /// - Parameters:
  ///   - condition: A closure to evaluate, if the closure returns true, shows the view it is applied to.
  /// - Returns: A view that conditionally shows the view it is applied to.
  @ViewBuilder func enabled(_ condition: () -> Bool) -> some View {
    if condition() { self }
  }
}
