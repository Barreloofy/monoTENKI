//
//  Image+Styled.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/9/25 at 12:09 PM.
//

import SwiftUI

extension Image {
  /// Applies the default image modifiers for this App,
  /// optionally specify an image size.
  func styled(size: CGFloat?) -> some View {
    self
      .resizable()
      .scaledToFit()
      .frame(width: size, height: size)
      .fontWeight(.regular)
  }
}
