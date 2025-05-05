//
//  Enabled.swift
//  monoTENKI
//
//  Created by Barreloofy on 5/3/25.
//

import SwiftUI

extension View {
  /// Conditionally shows the view it is applied to
  @ViewBuilder func enabled(_ condition: Bool) -> some View {
    if condition { self }
  }
}
