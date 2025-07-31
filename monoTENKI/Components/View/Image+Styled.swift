//
//  Image+Styled.swift
//  monoTENKI
//
//  Created by Barreloofy on 4/9/25 at 12:09 PM.
//

import SwiftUI

extension Image {
  /// The default configuration for Image.
  /// ## Overview
  /// The image may be smaller then the provided size,
  /// since a default aspect ratio is applied.
  /// - Parameters:
  ///   - size: The size of the image frame.
  func styled(size: CGFloat?) -> some View {
    self
      .resizable()
      .scaledToFit()
      .frame(width: size, height: size)
      .fontWeight(.regular)
  }
}
