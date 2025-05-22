//
//  Image+Styled.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/9/25 at 12:09 PM.
//

import SwiftUI
// Common image style
extension Image {
  /// Styles an image with the default modifiers: resizable(), scaledToFit(), fontWeight(.regular) and frame() where the methods argument 'size' will be passed to frame().
  func styled(size: CGFloat) -> some View {
    self
      .resizable()
      .scaledToFit()
      .fontWeight(.regular)
      .frame(width: size)
  }
}
